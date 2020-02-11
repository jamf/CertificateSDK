## Jamf Certificate SDK

###### Framework Architectures

The included framework ships with two simulator architectures (i386 and x86_64) and two device architectures
(armv7 and arm64).  This allows third-party app developers to use the framework both in their own simulators
running on their development Macs, and on actual devices.

When building the third-party app, only some of these architectures are going to be useful for an individual build of
the app.  The framework includes a bash script that should run within an Xcode "Run Script" build phase to thin out
the framework of unused architectures.  Look at the example app's Run Script build phase for a working example of
this.

`bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/CertificateSDK.framework/ios-strip-framework.sh" CertificateSDK`


#### Managed App Config Required Settings

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
