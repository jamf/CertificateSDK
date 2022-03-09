/*
 CertificateRequestDelegate.h

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
