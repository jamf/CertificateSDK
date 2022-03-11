// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CertificateSDK",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "CertificateSDK",
            targets: ["CertificateSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "CertificateSDK",
            path: "CertificateSDK.xcframework"
        )
    ]
)
