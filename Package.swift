// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SwiftonizePlugin",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .plugin(name: "Swiftonize", targets: ["SwiftonizeBuilder"]),
    ],
    dependencies: [
    ],
    targets: [

        .plugin(
            name: "SwiftonizeBuilder",
            capability: .buildTool(),
            dependencies: [
			]
        ),
		
    ]
)
