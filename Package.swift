import PackageDescription

let package = Package(
    name: "SelfTableViewManager",
    products: [
        .library(name: "SelfTableViewManager", targets: ["SelfTableViewManager"]),
    ],
    targets: [
        .target(name: "SelfTableViewManager", path: "SelfTableViewManager/Classes"),
    ],
    swiftLanguageVersions: [.v4]
)