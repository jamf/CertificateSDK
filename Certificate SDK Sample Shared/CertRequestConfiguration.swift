//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//

/// Contains the selected options for the test run
struct CertRequestConfiguration {
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
