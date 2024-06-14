## Jamf Certificate SDK

When the Jamf Certificate SDK is integrated with your iOS or visionOS app, it provides a secure process
that allows the app to request a certificate from a certificate authority (CA) via Jamf Pro. Certificates
can be used to establish identities that support certificate-based authentication to perform Single Sign-On
(SSO) or other actions specific to your environment.

See [Distributing an In-House App Developed with the Jamf Certificate SDK](https://learn.jamf.com/en-US/bundle/technical-paper-integrating-ad-cs-current/page/Distributing_an_In-House_App_Developed_with_the_Jamf_Certificate_SDK.html) for more details.

--------

### Installation

Jamf Certificate SDK is available through the [Swift Package Manager](https://swift.org/package-manager/).

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/jamf/CertificateSDK.git", from: "2.0.0")
```

--------

#### Framework Architectures

The included XCFramework ships with support for the iOS and visionOS simulators on Apple Silicon and Intel-based Mac computers, and iOS and visionOS devices using the arm64 architecture.  This allows app developers to use the
framework on actual iOS and visionOS devices and in the simulators while developing and testing their apps.

--------

### Managed App Configuration Required Settings

To ensure proper use of the SDK, the app is required to be distributed by Jamf Pro.  During distribution,
a managed app configuration can be specified that will let the SDK communicate with Jamf Pro and request
the proper certificate.  Here is a sample managed app configuration that can be used as a basis for your own app.

*Note that you can add your own key/value pairs to the managed app configuration to configure other parts of your app.*  Jamf's keys are all prefixed
with `com.jamf.config.` so they will not clash with your own naming conventions for keys.

    <dict>
    <key>com.jamf.config.jamfpro.invitation</key>
    <string>$MOBILEDEVICEAPPINVITE</string>
    <key>com.jamf.config.device.udid</key>
    <string>$MANAGEMENTID</string>
    <key>com.jamf.config.jamfpro.url</key>
    <string>https://the_jamf_pro_server_url_goes_here/</string>
    <key>com.jamf.config.certificate-request.pkiId</key>
    <string>1</string>
    <key>com.jamf.config.certificate-request.template</key>
    <string>User2</string>
    <key>com.jamf.config.certificate-request.subject</key>
    <string>cn=something</string>
    <key>com.jamf.config.certificate-request.sanType</key>
    <string>rfc822Name</string>
    <key>com.jamf.config.certificate-request.sanValue</key>
    <string>somebody@example.com</string>
    <key>com.jamf.config.certificate-request.signature</key>
    <string>$JAMF_SIGNATURE_com.jamf.config.certificate-request</string>
    </dict>

###### MAC key discussion

`com.jamf.config.device.udid`: The device identifier of the device the app is installed on.  Starting with
Jamf Pro 11.5.1, the value must be `$MANAGEMENTID` to support both company-owned and BYOD devices.  In Jamf
Pro 11.5.0 and earlier, the value must instead be `$UDID` and only company-owned devices are supported.

`com.jamf.config.jamfpro.url`: The value should be filled in with your Jamf Pro Server's URL.

The keys prefixed with `com.jamf.config.certificate-request` are used during certificate generation.  They
will be specific to your organization.  You should confer with those responsible for Jamf Pro and your
Certificate Authority to ensure the proper settings are configured for your app.

* `pkiId`: (an integer but typed as string in the MAC) Jamf Pro ID of the PKI Integration/Certificate Authority to be used; find this in the Jamf Pro
web UI at Settings > PKI Certificates > Your ADCS CA settings and then look in the URL bar for the number after "id=".  You should have a URL something like "adcsSettings.html?id=3" and enter the number `3` in the MAC
* `template`: (string) Certificate template name as defined in your CA
* `subject`: (string) Subject to include in the certificate signing request
* `sanType`: (string) One of 'rfc822Name', 'dNSName', or 'uniformResourceIdentifier'
* `sanValue`: (string) Subject Alternative Name to include in the certificate signing request

With the `subject` and `sanValue` fields, variable substitution is available as discussed under [Payload Variables for Configuration Profiles](https://learn.jamf.com/en-US/bundle/jamf-pro-documentation-current/page/Mobile_Device_Configuration_Profiles.html#ariaid-title3).

--

Additional reference documentation is available in
[Integrating the Jamf Certificate SDK with Mobile Device Apps Deployed by Jamf Pro](https://learn.jamf.com/bundle/jamf-certificate-sdk/page/Overview.html).
