//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
#ifndef CertificateRequestWorkflow_h
#define CertificateRequestWorkflow_h

#import <CertificateSDK/CertificateRequestBase.h>
#import <CertificateSDK/CertificateRequestProtocol.h>
#import <CertificateSDK/CertificateRequestDelegate.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class is the main class that should be instantiated to make a certificate request.
 */
NS_CLASS_AVAILABLE_IOS(10_0)
@interface CertificateRequestWorkflow : CertificateRequestBase <CertificateRequestProtocol>

/**
 Create an object.

 @param delegate Your delegate that will be called as the certificate request workflow proceeds
 @return An initialized object; may be nil if memory is full
 */
- (nullable instancetype)initWithDelegate:(id<CertificateRequestDelegate>)delegate;

/**
 Create an object with given settings instead of relying on Managed App Config.  This is a testing method.

 @param delegate Your delegate that will be called as the certificate request workflow proceeds
 @param testSettings The settings that would otherwise be provided by Managed App Config.
 @return An initialized object; may be nil if memory is full
 */
- (nullable instancetype)initWithDelegate:(id<CertificateRequestDelegate>)delegate testSettings:(NSDictionary *)testSettings;

/**
 Use this option to specify a custom timeout in seconds for individual network requests.
 Defaults to 30 seconds.
 */
@property (assign) NSUInteger networkingTimeout;

/**
 Use this option to specify a custom interval in seconds to poll for certificate creation.
 The first retrieval will happen after this interval, which means this also specifies the minimum
 amount of time required for the certificate request.  Minimum value is one second.
 Defaults to 5 seconds.
 */
@property (assign) NSUInteger pollingInterval;

/**
 Use this option to specify an overall timeout in seconds to poll for certificate creation.
 After this much time, if the server has still not returned a certificate then the certificate request
 will fail with a timeout error.
 Defaults to 180 seconds.
 */
@property (assign) NSUInteger pollingTimeout;

@end

NS_ASSUME_NONNULL_END

#endif /* CertificateRequestWorkflow_h */
