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
      name: "Cqoi"
    ),
    .target(
      name: "QuiteOkImage",
      dependencies: ["Cqoi"]
    ),
    .testTarget(
      name: "QuiteOkImageTests",
      dependencies: ["QuiteOkImage"]
    ),
  ]
)
