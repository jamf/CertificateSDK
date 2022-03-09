/*
 CertificateRequestWorkflow.h

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
