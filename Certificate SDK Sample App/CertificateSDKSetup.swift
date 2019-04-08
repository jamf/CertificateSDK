//
//  CertificateSDKSetup.swift
//  Certificate SDK Sample App
//
//  Copyright © 2018 Jamf. All rights reserved.
//

/// Contains the selected options for the test run
struct CertificateSDKSetup {
    var isActual: Bool
    var slowSpeed: Bool
    var simulateError: Bool

    var description: String {
        if isActual {
            return "Actual"
        }

        return "Simulated" + (slowSpeed ? " slow" : "") + (simulateError ? " with error" : "")
    }
}
