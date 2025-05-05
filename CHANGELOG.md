# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-05-01
### Added
- `keySize` support in the Managed App Config.
- Support for arrays of SAN type/value pairs in the Managed App Config.

## [2.0.0] - 2024-06-14
### Added
- visionOS support!  The compiled framework now includes support for visionOS v1.1 and
visionOS Simulator.  There is also a native visionOS sample app that works just like
the iOS sample app.
- The CertificateSDK.xcframework is now signed by Jamf for added security.
### Changed
- Moved the Package.swift tool version from Swift 5.3 to Swift v5.9 in order to support visionOS.
- Moved the iOS minimum deployment target from v10 to v12.
- Described how to use `$MANAGEMENTID` to support BYOD devices with Jamf Pro v11.5.1 and newer.
### Removed
- Removed PDF file titled "Integrating the Jamf Certificate SDK into your iOS App".  This information
is now available online.  See the bottom of the README file for a link.

## [1.1.1] - 2022-03-11
### Changed
- Modified the name of the target in the `Package.swift` file so that Xcode 13.3 can find the artifact.

## [1.1.0] - 2021-01-08
### Added
- The compiled framework now includes simulator code for simulators running on Macs with Apple Silicon.
- Added a `Package.swift` file for integration with Swift Package Manager.

### Changed
- The compiled framework is now an XCFramework to allow easy integration with Xcode 12 projects.

### Fixed
- Fixed an issue that caused two `certificate(request:error:)` calls to be made to the delegate if the SDK could not reach Jamf Pro to request a new AppConfig.

## [1.0.1] - 2020-02-11
### Added
- This CHANGELOG.md file.

### Changed
- The Jamf Certificate SDK now adds an interval to the time specified in the pollingTimeout setting. This enables the SDK to retrieve the Managed App Configuration prior to starting the specified pollingTimeout seconds.
- The Jamf Certificate SDK has been re-licensed under the MIT License.

### Fixed
- The Jamf Certificate SDK now properly handles network errors and status updates when making requests for a new Managed App Configuration.
- Fixed an issue that prevented the progress of steps from starting at zero and incrementing by one up to the maxNumberOfSteps.
- Fixed an issue that prevented the NSError object from being correctly sent into the `certificateRequest:errorOccurred:` delegate method.

## [1.0.0] - 2018-07-24
### Added
- Initial release.
