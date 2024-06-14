//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import CertificateSDK

class CertificateRequestManager: NSObject {
    let keychainHelper = KeychainHandler()

    var textOutputHandler: ((String) -> Void)?
    var progressHandler: ((Float) -> Void)?

    private var certificateRequest: CertificateRequestProtocol?

    /// Starts a new request with the given configuration; does nothing if a request is currently pending.
    ///
    /// - Parameter configuration: The type of certificate request to start
    func startRequest(with configuration: CertRequestConfiguration) {
        guard certificateRequest == nil else {
            // do nothing.  Let the user try to run the test or re-run the test once the request is nil.
            return
        }

        if configuration.isActual {
            certificateRequest = CertificateRequestWorkflow(delegate: self)
        } else {
            var localRequest: CertificateRequestEmbeddedP12?
            if !configuration.simulateError, let p12 = Bundle.main.url(forResource: "test_certificate",
                                                               withExtension: "p12") {
                localRequest = CertificateRequestEmbeddedP12(delegate: self, p12File: p12, p12Password: "abc123")
            } else {
                localRequest = CertificateRequestEmbeddedP12(delegate: self,
                                                             p12File: URL(fileURLWithPath: ""),
                                                             p12Password: "a")
            }

            if configuration.slowSpeed {
                localRequest?.secondsBetweenSteps = 2
            }
            certificateRequest = localRequest
        }

        certificateRequest?.startNewCertificateRequest()
    }

    /// Stop any pending certificate request.
    func cancelPendingRequest() {
        certificateRequest?.cancelRequest()
        certificateRequest = nil
    }
}

typealias CertificateRequestHandler = CertificateRequestManager

extension CertificateRequestHandler: CertificateRequestDelegate {

    func certificate(request: CertificateRequestProtocol, error: Error) {
        self.textOutputHandler?("Error: \(error.localizedDescription)")
    }

    func certificate(request: CertificateRequestProtocol, completedWith identity: SecIdentity?) {
        certificateRequest = nil

        if let actualIdentity = identity {
            self.textOutputHandler?("Request completed with identity \(actualIdentity)")
            self.textOutputHandler?(self.keychainHelper.addKeychain(identity: actualIdentity))
        } else {
            self.textOutputHandler?("Request completed with identity nil")
        }

        self.textOutputHandler?(self.keychainHelper.showCertificateInfo())
    }

    func certificateRequest(_ request: CertificateRequestProtocol, progress current: UInt) {
        self.textOutputHandler?("Progress: \(current) of \(request.maxNumberOfSteps)")

        self.progressHandler?(Float(current) / Float(request.maxNumberOfSteps))
    }

    func certificateRequest(_ request: CertificateRequestProtocol, isUsingNetwork: Bool) {
        self.textOutputHandler?("Using network: \(isUsingNetwork)")
    }

    func certificateRequest(_ request: CertificateRequestProtocol, isWaitingForMAC waitingForMAC: Bool) {
        self.textOutputHandler?("Waiting for AppConfig: \(waitingForMAC)")
    }
}
