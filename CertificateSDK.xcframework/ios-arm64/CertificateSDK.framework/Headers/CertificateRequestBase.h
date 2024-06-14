//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
#ifndef CertificateRequestBase_h
#define CertificateRequestBase_h

#import <Foundation/Foundation.h>
#import <CertificateSDK/CertificateRequestDelegate.h>
#import <CertificateSDK/CertificateRequestProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class is the base class for all CertificateRequestProtocol objects.
 Subclasses will have a concrete implementation of requesting certificates.
 */
NS_CLASS_AVAILABLE_IOS(10_0)
@interface CertificateRequestBase : NSObject <CertificateRequestProtocol>

/**
 The object that will be called back with progress, errors, and completion.
 */
@property (weak, readonly) id<CertificateRequestDelegate> delegate;

/**
 This is the maximum number of steps in the progress of a certificate request.
 May be approximate until the actual call of -startNewCertificateRequest
 */
@property (assign, readonly) NSUInteger maxNumberOfSteps;

/**
 Create an object.

 @param delegate Your delegate that will be called as the certificate request workflow proceeds
 @return An initialized object; may be nil if memory is full
 */
- (nullable instancetype)initWithDelegate:(id<CertificateRequestDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif /* CertificateRequestBase_h */
