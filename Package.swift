// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CertificateSDK",
    platforms: [
        .iOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "CertificateSDK", targets: ["CertificateSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "CertificateSDK", path: "CertificateSDK.xcframework"
        )
    ]
)
