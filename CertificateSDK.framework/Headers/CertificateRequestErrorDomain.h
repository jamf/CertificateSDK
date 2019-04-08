/*
  CertificateErrorDomain.h
  CertificateSDK

 Copyright © 2018 Jamf. All rights reserved.

 This Jamf software is covered by the "Jamf Certificate SDK License".
 The first two sections are included here for reference, but please refer
 to the complete Jamf Certificate SDK License which is included in the SDK.

 1. License Grant. Jamf hereby grants Licensee a limited, nonexclusive, nontransferable,
 nonsublicensable, royalty free, fully paid up right to use the Jamf Pro software development
 kit (“SDK”) solely for integrating Jamf Pro into the Licensee Product; and copy, distribute,
 and connect with other software Jamf Pro as integrated into the LIcensee product, which it
 may sell or offer to sell, or authorize others to the same, to end users.

 2. License Restrictions. The SDK is provided under a license, not sold. Except for the rights
 expressly granted by Jamf to Licensee above, there are no other licenses granted to Licensee
 under this Agreement, express or implied, and Jamf reserves all rights, title, and interest in
 and to the SDK. Licensee will not engage, directly or indirectly, in the disassembly, reverse
 engineering, decompilation, modification, or translation of the SDK. Licensee will not copy and
 sell the SDK as a stand-alone package nor create derivative works of the SDK without the prior
 written consent of Jamf. Licensee shall not remove or destroy any proprietary, confidential,
 copyright, trademark, or patent markings or notices placed upon the SDK.
 */

#ifndef CertificateErrorDomain_h
#define CertificateErrorDomain_h

/**
 The error domain specific to the Jamf Certificate SDK.
 */
extern NSString * const kCertificateRequestErrorDomain;

/**
 Errors specific to the Jamf Certificate SDK

 - kErrorBadInitializationParams: A CertificateRequestEmbeddedP12 object was initialized with bad parameters.
 - kErrorCertificateMalformed: Unlikely to happen.  The certificate coming from Jamf Pro has been mangled in transit.
 - kErrorCertificateWrongAutomaticPassword: Unlikely to happen.  Occurs when the .p12 from the server was encrypted with a different password than the SDK has chosen.
 - kErrorIncorrectManagedAppConfigData: The Managed App Config info does not contain enough information to contact Jamf Pro.
 - kErrorInvalidResponseFromJamfProServer: Unlikely to happen.  The Jamf Pro server responded with info that the SDK does not understand.
 */
NS_ERROR_ENUM(kCertificateRequestErrorDomain) {
    kErrorBadInitializationParams = 1,
    kErrorCertificateMalformed = 2,
    kErrorCertificateWrongAutomaticPassword = 3,
    kErrorIncorrectManagedAppConfigData = 4,
    kErrorInvalidResponseFromJamfProServer = 5
};

#endif /* CertificateErrorDomain_h */
