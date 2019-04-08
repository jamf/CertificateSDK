//
//  KeychainHandler.swift
//  Certificate SDK Sample App
//
//  Copyright © 2018 Jamf. All rights reserved.
//

import Foundation

struct KeychainHandler {
    let kMyIdentityLabel = "Jamf Sample App Identity Label"

    func addKeychain(identity: SecIdentity) -> String {
        // This specifies the identity is added only if the device has a passcode and it will not sync to other devices.
        // If this should be used in other apps signed by your Developer ID, add a kSecAttrAccessGroup key and value.
        let query = [kSecValueRef: identity,
                     kSecAttrLabel: kMyIdentityLabel,
                     kSecAttrAccessible: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly] as CFDictionary
        let status = SecItemAdd(query, nil)
        switch status {
        case errSecDuplicateItem:
            return "Keychain item already exists"
        case errSecSuccess:
            return "Keychain item added"
        default:
            return "Keychain add resulted in status: \(status)"
        }
    }

    func clearKeychain() -> String {
        var resultString = ""
        let query = [kSecMatchLimit: kSecMatchLimitAll,
                     kSecReturnAttributes: kCFBooleanTrue,
                     kSecReturnRef: kCFBooleanTrue,
                     kSecClass: kSecClassIdentity] as CFDictionary
        var result: CFTypeRef? = nil
        let resultCode = SecItemCopyMatching(query, &result)

        if resultCode == errSecSuccess {
            let actualResult = result!
            if CFArrayGetTypeID() == CFGetTypeID(actualResult) {
                let array = (actualResult as? NSArray) as? [NSDictionary]
                array?.forEach { (item) in
                    resultString += self.deleteIdentity(item)
                }
            } else {
                resultString += self.deleteIdentity((result as? NSDictionary)!)
            }
        }

        return resultString
    }

    func deleteIdentity(_ identity: NSDictionary) -> String {
        if let label = identity[kSecAttrLabel] as? String, label == kMyIdentityLabel {
            let query = [kSecValueRef: identity[kSecValueRef]] as CFDictionary
            let status = SecItemDelete(query)
            if status != errSecSuccess {
                return "Item delete result: \(status)\n"
            }
        }
        return ""
    }

    func showCertificateInfo() -> String {
        var resultString = "--- Certificates in Keychain ---\n"
        var outputACert = false
        let query = [kSecMatchLimit: kSecMatchLimitAll,
                     kSecReturnRef: kCFBooleanTrue,
                     kSecClass: kSecClassCertificate] as CFDictionary
        var result: CFTypeRef? = nil
        let resultCode = SecItemCopyMatching(query, &result)

        if resultCode == errSecSuccess {
            if CFArrayGetTypeID() == CFGetTypeID(result) {
                let array = (result as? NSArray) as? [SecCertificate]
                array?.forEach { (item) in
                    resultString += self.displayCertificate(item)
                    outputACert = true
                }
            } else {
                // swiftlint:disable force_cast
                resultString += self.displayCertificate(result as! SecCertificate)
                // swiftlint:enable force_cast
                outputACert = true
            }
        }

        if !outputACert {
            resultString += "None\n"
        }
        resultString += "-------------------------------"
        return resultString
    }

    func displayCertificate(_ certificate: SecCertificate) -> String {
        let subject = SecCertificateCopySubjectSummary(certificate) as String?
        return "Cert Subject: \(subject ?? "nil")\n"
    }
}
