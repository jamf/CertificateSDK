/*
  CertificateRequestProtocol.h
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

#ifndef CertificateRequestProtocol_h
#define CertificateRequestProtocol_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This is the protocol used for requesting and renewing certificates from Jamf Pro.
 */
@protocol CertificateRequestProtocol

/**
 This is the maximum number of steps in the progress of a certificate request.
 May be approximate until the actual call of -startNewCertificateRequest
 */
@property (assign, readonly) NSUInteger maxNumberOfSteps;

/**
 This will start a request to the Jamf Pro server for a new certificate.
 The delegate will be called with progress, errors, and the new identity.
 NOTE: Only one such request should be in progress at a given time for a single CertificateRequest object.
 */
- (void)startNewCertificateRequest;

/**
 Cancels the current request, if any.  The completion handler WILL be called on the delegate.
 */
- (void)cancelRequest;

@end

NS_ASSUME_NONNULL_END

#endif /* CertificateRequestProtocol_h */
