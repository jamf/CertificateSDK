/*
 CertificateRequestBase.h

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
