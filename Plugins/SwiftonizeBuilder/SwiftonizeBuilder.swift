import PackagePlugin
import Foundation

struct XcodeExtraConfig: Decodable {
	var python_site_path: String?
	var external_swift_folders: [String]
}

@main
struct SwiftonizeBuilder: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let _ = target.sourceModule?.sourceFiles else { return [] }
		
		print("target.name",target.name)
		print("target.directory",target.directory)
		print("context.package.displayName",context.package.displayName)
		print("context.pluginWorkDirectory",context.pluginWorkDirectory)
		print("context.package.directory",context.package.directory)
        
		let input = target.directory.appending(subpath: "wrappers")

		return [
            try .swiftonize(
                input: input,
                context: context
            )

		]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftonizeBuilder: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        
        
        let input = context.xcodeProject.directory.appending(subpath: "wrapper_sources")
		print("Swiftonize XC Plugin!!!")
        print(input)

//		
//		var config: XcodeExtraConfig? = nil
//		do {
//			let configFile = context.xcodeProject.directory.appending(subpath: "config.json")
//			let configData = try Data(contentsOf: .init(filePath: configFile.string))
//			config = try JSONDecoder().decode(XcodeExtraConfig.self, from: configData)
//		} catch _ {}
		
        return [
            try .swiftonize(
                input: input,
                context: context,
                target: target
            )
        ]
    }
    
}

#endif


