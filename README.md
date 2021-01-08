## Jamf Certificate SDK

--------

### Installation

Jamf Certificate SDK is available through the [Swift Package Manager](https://swift.org/package-manager/).

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/jamf/CertificateSDK.git", from: "1.1.0")
```

--------

#### Framework Architectures

The included XCFramework ships with three simulator architectures (arm64, i386, and x86_64) and two device architectures
(armv7 and arm64).  This allows third-party app developers to use the framework both in their own simulators
running on their development Macs (including Apple Silicon), and on actual devices.

--------

### Managed App Config Required Settings

To ensure proper use of the SDK, the iOS app is required to be distributed by Jamf Pro.  During distribution, an App Configuration
can be specified that will let the SDK communicate with Jamf Pro and request the proper certificate.  Here is a sample App Configuration
that can be used as a basis for your own app.

*Note that you can add your own key/value pairs to the App Configuration to configure other parts of your app.*  Jamf's keys are all prefixed
with `com.jamf.config.` so they will not clash with your own naming conventions for keys.

    <dict>
    <key>com.jamf.config.jamfpro.invitation</key>
    <string>$MOBILEDEVICEAPPINVITE</string>
    <key>com.jamf.config.device.udid</key>
    <string>$UDID</string>
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

com.jamf.config.jamfpro.url: The value should be filled in with your Jamf Pro Server's URL.

The keys prefixed with `com.jamf.config.certificate-request` are used during certificate generation.  They will
be specific to your organization.  You should confer with those responsible for Jamf Pro and your Certificate Authority to ensure
the proper settings are configured for your app.

* pkiId: (an integer but typed as string in the MAC)  Jamf Pro ID of the PKI Integration/Certificate Authority to be used; find this in the Jamf Pro
web UI at Settings > PKI Certificates > Your ADCS CA settings and then look in the URL bar for the number after "id=".  You should have a URL something like "adcsSettings.html?id=3"
* template: (string) Certificate template name as defined in your CA
* subject: (string) Subject to include in the certificate signing request
* sanType: (string) One of 'rfc822Name', 'dNSName', or 'uniformResourceIdentifier'
* sanValue: (string) Subject Alternative Name to include in the certificate signing request

With the subject and sanValue fields, variable substitution is available as discussed under "Payload Variables for Mobile Device Configuration Profiles" at
http://docs.jamf.com/jamf-pro/administrator-guide/Mobile_Device_Configuration_Profiles.html
