//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
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
