//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
#ifndef CertificateRequestEmbeddedP12_h
#define CertificateRequestEmbeddedP12_h

#import <CertificateSDK/CertificateRequestBase.h>
#import <CertificateSDK/CertificateRequestProtocol.h>
#import <CertificateSDK/CertificateRequestDelegate.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class reads the certificate from an embedded p12 file, and can force errors for testing.
 */
NS_CLASS_AVAILABLE_IOS(10_0)
@interface CertificateRequestEmbeddedP12 : CertificateRequestBase <CertificateRequestProtocol>

/**
 Create an object.

 @param delegate Your delegate that will be called as the certificate request workflow proceeds
 @param p12URL A URL to a file with a .p12 certificate that will be returned
 @param pwd The password for the .p12 file
 @return An initialized object; may be nil if memory is full
 */
- (nullable instancetype)initWithDelegate:(id<CertificateRequestDelegate>)delegate
                         p12File:(NSURL *)p12URL
                     p12Password:(NSString *)pwd;

/**
 Use this option to artificially delay the completion of each step.  Each step up to maxNumberOfSteps will take this many seconds.
 This allows you to test things that are hard to test otherwise, such as progress.
 Defaults to zero (full speed).
 */
@property (assign) NSUInteger secondsBetweenSteps;

@end

NS_ASSUME_NONNULL_END

#endif /* CertificateRequestEmbeddedP12_h */
