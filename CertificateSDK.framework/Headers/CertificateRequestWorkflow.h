/*
  CertificateRequestWorkflow.h
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
