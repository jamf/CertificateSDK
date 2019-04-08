/*
  CertificateRequestDelegate.h
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

#ifndef CertificateRequestDelegate_h
#define CertificateRequestDelegate_h

NS_ASSUME_NONNULL_BEGIN

@protocol CertificateRequestProtocol;

/**
 Third party apps should have a class that implements these methods for notification on progress, errors, and completion.
 */
@protocol CertificateRequestDelegate <NSObject>

@required
/**
 When any kind of error occurs in the process for requesting certificates, this delegate method will be called.

 @param request The object that initiated the request
 @param error An error object
 */
- (void)certificateRequest:(id<CertificateRequestProtocol>)request errorOccurred:(NSError *)error NS_SWIFT_NAME(certificate(request:error:));

@required
/**
 When the request to Jamf Pro is completed, this method will be called.  If there were errors, the identity will be nil.

 @param request The object that started the request.
 @param identity An identity that encapsulates the info from the server.
 */
- (void)certificateRequest:(id<CertificateRequestProtocol>)request completedWithIdentity:(nullable SecIdentityRef)identity
NS_SWIFT_NAME(certificate(request:completedWith:));

@optional
/**
 As the steps are completed during the request to Jamf Pro, this method can be called.  The current progress can be checked
 against the request.maxNumberOfSteps to show progress percentage.
 NOTE: Each step may take a different (unknown) amount of time as the actual request will be using network resources.

 @param request The object that started the request.
 @param current The current progress 
 */
- (void)certificateRequest:(id<CertificateRequestProtocol>)request progress:(NSUInteger)current;

@optional
/**
 When the CertificateRequest SDK begins accessing the network and when it ends accessing the network, this method
 is called if implemented.

 @param request The object that started the request.
 @param isUsingNetwork Whether or not the request is currently using the network.
 */
- (void)certificateRequest:(id<CertificateRequestProtocol>)request isUsingNetwork:(BOOL)isUsingNetwork;


@optional
/**
 When the CertificateRequest SDK detects no settings in the Managed App Config key, or if the invitation in the
 Managed App Config has expired this will be called to let you know that it is waiting for a new MAC to be delivered
 from the Jamf Pro server.  Will be called again when the MAC comes in; the timing on this can vary greatly.

 @param request The object that started the request.
 @param waitingForMAC Whether or not the request is currently waiting for settings in the Managed App Config.
 */
- (void)certificateRequest:(id<CertificateRequestProtocol>)request isWaitingForMAC:(BOOL)waitingForMAC;

@end

NS_ASSUME_NONNULL_END

#endif /* CertificateRequestDelegate_h */
