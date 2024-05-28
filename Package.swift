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
        .plugin(name: "Swiftonizer", targets: ["SwiftonizeBuilder"]),
		//.plugin(name: "SwiftonizerExt", targets: ["SwiftonizeBuilderExt"]),
		//.plugin(name: "SwiftonizerNew", targets: ["SwiftonizeBuilderNew"]),
		//.executable(name: "RunPlaygrounds", targets: ["Playgrounds"])
    ],
    dependencies: [
        //.package(url: "https://github.com/PythonSwiftLink/Swiftonize", branch: "testing"),
        //.package(path: "../Swiftonize-development"),
//        .package(url: "https://github.com/kylef/PathKit", from: .init(1, 0, 0)),
//        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
//        .package(url: "https://github.com/tomlokhorst/XcodeEdit", from: "2.9.0"),
		//.package(url: "https://github.com/PythonSwiftLink/PythonSwiftLink-development", branch: "master"),
		//.package(path: "../PythonSwiftLink-development"),
		//.package(path: "../Swiftonize"),
		.package(url: "https://github.com/kylef/PathKit", from: .init(1, 0, 0) ),
		//.package(url: "https://github.com/apple/swift-syntax", from: .init(509, 0, 0) ),
		
		
		//.package(url: "https://github.com/apple/swift-argument-parser", from: .init(1, 2, 0))
    ],
    targets: [

        .plugin(
            name: "SwiftonizeBuilder",
            capability: .buildTool(),
            dependencies: [
				//"swiftonize",
				//"SwiftonizeExecutable"
			]
        ),
		//.plugin(name: <#T##String#>, capability: .command(intent: <#T##PluginCommandIntent#>, permissions: <#T##[PluginPermission]#>))
//		.executableTarget(
//			name: "Playgrounds",
//			dependencies: [
//				.product(name: "PySwiftCore", package: "PythonSwiftLink-development"),
//				//.product(name: "SwiftonizeNew", package: "Swiftonize"),
//				//.product(name: "PyWrapper", package: "Swiftonize"),
//				.product(name: "PySwiftObject", package: "PythonSwiftLink-development"),
//				"PathKit",
//				"PythonResources"
//			],
//			plugins: ["SwiftonizeBuilderNew"]
//		),
//		.target(
//			name: "PythonResources",
//			resources: [
//				.copy("python-stdlib"),
//				.copy("python-extra")
//			]
//		),
//		.target(
//			name: "SwiftonizeTest",
//			dependencies: [
//				"SwiftonizeFW"
//			]
//		),
//			.executableTarget(
//				name: "SwiftonizeExecutable",
//				dependencies: [
////					.product(name: "SwiftSyntax", package: "swift-syntax"),
////					.product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
//					.product(name: "ArgumentParser", package: "swift-argument-parser"),
//					//.product(name: "PySwiftCore", package: "PythonSwiftLink-development"),
////					.product(name: "SwiftonizeNew", package: "Swiftonize-development"),
////					.product(name: "PyWrapper", package: "Swiftonize-development"),
//					//.product(name: "PySwiftObject", package: "PythonSwiftLink"),
//					"PathKit",
//					//"PythonResources"
//				]
//			),
		//.binaryTarget(name: "SwiftonizeFW", path: "SwiftonizeFW.xcframework")
    ]
)
