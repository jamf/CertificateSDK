# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2020-01
### Added
- This CHANGELOG.md file.

### Changed
- The Jamf Certificate SDK now adds an interval to the time specified in the pollingTimeout setting. This enables the SDK to retrieve the Managed App Configuration prior to starting the specified pollingTimeout seconds.
- The Jamf Certificate SDK has been re-licensed under the MIT License.

### Fixed
- The Jamf Certificate SDK now properly handles network errors and status updates when making requests for a new Managed App Configuration.
- Fixed an issue that prevented the progress of steps from starting at zero and incrementing by one up to the maxNumberOfSteps.
- Fixed an issue that prevented the NSError object from being correctly sent into the certificateRequest:errorOccurred: delegate method.

## [1.0.0] - 2018-07-24
### Added
- Initial release.
