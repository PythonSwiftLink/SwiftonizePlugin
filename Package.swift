// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SwiftonizePlugin",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
//        .executable(name: "TestPlugin", targets: [
//            "TestPlugin"
//        ]),
//        .plugin(
//            name: "BuildToolPluginA",
//            targets: ["BuildToolPluginA"]),
//        
		
        //.executable(name: "swiftonize", targets: ["swiftonize"]),
		//.executable(name: "SwiftonizeExec", targets: ["SwiftonizeExec"]),
        .plugin(name: "Swiftonize", targets: ["SwiftonizeBuilder"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/PythonSwiftLink/Swiftonize", branch: "testing"),
//        .package(path: "../Swiftonize"),
//        .package(url: "https://github.com/kylef/PathKit", from: .init(1, 0, 0)),
//        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
//        .package(url: "https://github.com/tomlokhorst/XcodeEdit", from: "2.9.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
		//.executableTarget(name: "SwiftonizeExec"),
//        .executableTarget(
//            name: "swiftonize",
//            dependencies: [
////                "Swiftonize",
////                "PathKit",
////                .product(name: "ArgumentParser", package: "swift-argument-parser"),
////                "XcodeEdit"
//            ],
//            resources: [
//                .copy("python_stdlib"),
//                .copy("python-extra"),
//				//.process("SwiftonizeExec")
//            ]
//        ),
        .plugin(
            name: "SwiftonizeBuilder",
            capability: .buildTool(),
            dependencies: [
				//"swiftonize",
			]
			//sources: ["SwiftonizeExec"]
        ),
		//.binaryTarget(name: "SwiftonizeFramework", path: "../SwiftonizeFramework")
    ]
)
