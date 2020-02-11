/*
 CertificateRequestErrorDomain.h

 https://github.com/jamf/CertificateSDK

 MIT License

 Copyright (c) 2019 Jamf Open Source Community

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
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
