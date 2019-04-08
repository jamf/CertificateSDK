//
//  ActionLogViewController.swift
//  Certificate SDK Sample App
//
//  Copyright © 2018 Jamf. All rights reserved.
//

import UIKit
import CertificateSDK

class ActionLogViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var actionLogTextView: UITextView!

    let keychainHelper = KeychainHandler()
    let requestManager = (UIApplication.shared.delegate as? AppDelegate)?.requestManager

    var setup: CertificateSDKSetup?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestManager?.textOutputHandler = { [weak self] (newText) in
            self?.append(newText)
        }

        requestManager?.progressHandler = { [weak self] (progressPercent) in
            self?.updateProgress(progressPercent)
        }

        resetBaseTextView()
        runTest()
    }

    // MARK: -

    /// Runs the same test that has already been defined.
    ///
    /// - Parameter sender: unused
    @IBAction func rerunTest(_ sender: Any) {
        runTest()
    }

    /// Stop any current request; clear the keychain; clear the action log
    ///
    /// - Parameter sender: unused
    @IBAction func reset(_ sender: Any) {
        requestManager?.cancelPendingRequest()
        _ = keychainHelper.clearKeychain()
        self.resetBaseTextView()
        self.progressView.progress = 0
    }

    // MARK: -

    func runTest() {
        // Start a new certificate request.
        if let sdkSetup = setup {
            requestManager?.cancelPendingRequest()
            requestManager?.startRequest(with: sdkSetup)
        }
    }

    func resetBaseTextView() {
        // Update the user interface for the detail item.
        if let sdkSetup = setup, let textView = actionLogTextView {
            textView.text = "Setup: \(sdkSetup.description)"

            self.append( keychainHelper.showCertificateInfo() )
        }
    }

    func append(_ logText: String) {
        DispatchQueue.main.async(execute: {
            if let textView = self.actionLogTextView {
                let existingText = textView.text ?? ""
                let newText = "\(existingText)\n\(logText)"
                textView.text = newText

                // Autoscroll as text is added to the bottom.
                let lastChar = NSRange(location: (newText as NSString).length - 1, length: 1)
                textView.scrollRangeToVisible(lastChar)
            }
        })
    }

    func updateProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
    }
}
