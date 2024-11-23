// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "QuiteOkImage",
  products: [
    .library(
      name: "QuiteOkImage",
      targets: ["QuiteOkImage"])
  ],
  targets: [
    .target(
      name: "QuiteOkImage"),
    .testTarget(
      name: "QuiteOkImageTests",
      dependencies: ["QuiteOkImage"]
    ),
  ]
)
