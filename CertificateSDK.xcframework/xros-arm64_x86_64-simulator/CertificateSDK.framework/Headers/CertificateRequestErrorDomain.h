//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
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
 - kErrorTestingP12LoadFailed: Unlikely to happen.  When using the testing class CertificateRequestEmbeddedP12 this is a generic error that the p12 failed to load.
 */
NS_ERROR_ENUM(kCertificateRequestErrorDomain) {
    kErrorBadInitializationParams = 1,
    kErrorCertificateMalformed = 2,
    kErrorCertificateWrongAutomaticPassword = 3,
    kErrorIncorrectManagedAppConfigData = 4,
    kErrorInvalidResponseFromJamfProServer = 5,
    kErrorTestingP12LoadFailed = 6
};

#endif /* CertificateErrorDomain_h */
