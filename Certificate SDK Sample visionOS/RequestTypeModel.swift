//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import Foundation

/// Contains the selected options for the test run for use with visionOS
class RequestTypeModel: ObservableObject {
    /// Whether to make actual network requests for the certificate or to use the built-in p12 file
    @Published var isActual: Bool
    /// If true, simulates a slower network speed.
    @Published var slowSpeed: Bool
    /// If true, ends the certificate request in an error.
    @Published var simulateError: Bool
    /// The complete output text shown in the Action Log
    @Published var completeOutput = ""
    /// The progress (from 0.0 to 1.0) of the network request
    @Published var progress = 0.0
    /// True when the local notification has been scheduled
    @Published var notificationScheduled = false

    /// The certificate request manager; the ``RequestTypeModel`` owns the
    /// instance of the ``CertificateRequestManager``.
    let requestManager: CertificateRequestManager

    init(isActual: Bool = false, slowSpeed: Bool = true, simulateError: Bool = false) {
        self.isActual = isActual
        self.slowSpeed = slowSpeed
        self.simulateError = simulateError
        self.completeOutput = ""
        self.progress = 0.0
        self.requestManager = CertificateRequestManager()
        LocalNotificationService.shared.requestManager = self.requestManager
    }

    var description: String {
        if isActual {
            return "Actual"
        }

        return "Simulated" + (slowSpeed ? " slow" : "") + (simulateError ? " with error" : "")
    }

    func runTest(resetOutput: Bool) {
        requestManager.textOutputHandler = { (text: String) in
            self.append(text: text)
        }

        requestManager.progressHandler = { (progress: Float) in
            DispatchQueue.main.async {
                self.progress = Double(progress)
            }
        }

        if resetOutput {
            completeOutput = "Setup: \(description)"
            progress = 0.0
        }

        let testConfiguration = CertRequestConfiguration(isActual: isActual,
                                                         slowSpeed: slowSpeed,
                                                         simulateError: simulateError)
        requestManager.cancelPendingRequest()
        requestManager.startRequest(with: testConfiguration)
    }

    func reset() {
        requestManager.cancelPendingRequest()
        _ = requestManager.keychainHelper.clearKeychain()

        progress = 0.0

        completeOutput = "Setup: \(description)"
        append(text: requestManager.keychainHelper.showCertificateInfo())
    }

    func scheduleNotification() {
        notificationScheduled = true

        let notificationService = LocalNotificationService.shared

        // A real app should schedule the notification to renew on some date in the future.
        notificationService.scheduleLocalNotificationForRenewal(Date(timeIntervalSinceNow: 60))

        // Reset back to schedule notification after 4 seconds.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0, qos: .background) {
            self.notificationScheduled = false
        }
    }

    private func append(text: String) {
        DispatchQueue.main.async {
            self.completeOutput += "\n\(text)"
        }
    }
}
