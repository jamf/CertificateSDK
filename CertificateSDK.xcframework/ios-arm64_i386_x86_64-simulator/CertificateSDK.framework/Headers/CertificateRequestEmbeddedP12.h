/*
 CertificateRequestEmbeddedP12.h

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
