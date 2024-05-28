import PackagePlugin
import Foundation

struct XcodeExtraConfig: Decodable {
	var python_site_path: String?
	var external_swift_folders: [String]
}

enum SwiftonizeError: Error {
	case fileNotFound(path: String)
}

#if arch(arm64)
let SwiftonizeExec: Path = .init("/opt/homebrew/bin/Swiftonize_dev")
#else
let SwiftonizeExec: Path =  .init("/usr/local/bin/Swiftonize_dev")
//let SwiftonizeExec: Path = .init("/Volumes/CodeSSD/PSL-development/SwiftonizeExec-development/SwiftonizeBin")
#endif

let python_stdlib = "/usr/local/bin/Swiftonize/python_stdlib"
let python_extra = "/usr/local/bin/Swiftonize/python-extra"
@main
struct SwiftonizeBuilder: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }
		
        // Find the code generator tool to run (replace this with the actual one).
        //let generatorTool = try context.tool(named: "SwiftonizeBuilder")
		print("target.name",target.name)
		print("target.directory",target.directory)
		print("context.package.displayName",context.package.displayName)
		print("context.pluginWorkDirectory",context.pluginWorkDirectory)
		print("context.package.directory",context.package.directory)
		
		let input = target.directory.appending(subpath: "wrappers")
		//let input = context.pluginWorkDirectory.appending(subpath: "jsons")
		let outputFiles = try FileManager.default.contentsOfDirectory(atPath: input.string).compactMap({ file -> Path? in
			let _file = Path(file)
			if _file.lastComponent == ".DS_Store" { return nil }
			guard _file.extension == "json" else { return nil }
			let root = context.pluginWorkDirectory
			let name = _file.stem
			return root.appending(subpath: "\(name).swift")
		})
		
        // Construct a build command for each source file with a particular suffix.
//        return sourceFiles.map(\.path).compactMap {
//            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
//        }
		var arguments: [CustomStringConvertible] = [
			"json",
			input,
			context.pluginWorkDirectory,
			//"--site", "/Users/codebuilder/Library/Mobile Documents/com~apple~CloudDocs/Projects/xcode_projects/touchBay_files/rebuild/touchBay/venv_test"
//			python_stdlib,
//			python_extra
		]

		return [
			.buildCommand(
				displayName: "Swiftonize(\(context.package.displayName))",
				executable: SwiftonizeExec,
				arguments: arguments,
				outputFiles: outputFiles
			)
		]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftonizeBuilder: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func _createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Find the code generator tool to run (replace this with the actual one).
        let generatorTool = try context.tool(named: "SwiftonizeBuilder")

        // Construct a build command for each source file with a particular suffix.
        return target.inputFiles.map(\.path).compactMap {
            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
			
        }
    }
    
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        
        
        let input = context.xcodeProject.directory.appending(subpath: "wrapper_sources")
        print(input)
        let resourcesDirectoryPath = context.pluginWorkDirectory
//            .appending(subpath: target.displayName)
//            .appending(subpath: "Resources")
//
//        try FileManager.default.createDirectory(atPath: resourcesDirectoryPath.string, withIntermediateDirectories: true)

        let rswiftPath = resourcesDirectoryPath//.appending(subpath: "R.generated.swift")
        print(input)
        print(rswiftPath)
		if !FileManager.default.fileExists(atPath: input.string) {
			print("warning: \(input) dont exist")
			throw SwiftonizeError.fileNotFound(path: input.string)
		}
		
        let outputFiles = try FileManager.default.contentsOfDirectory(atPath: input.string).compactMap({ file -> Path? in
            let _file = Path(file)
			if _file.lastComponent == ".DS_Store" { return nil }
            let root = resourcesDirectoryPath
            let name = _file.stem
            return root.appending(subpath: "\(name).swift")
        })
        let description: String
        if let product = target.product {
            description = "\(product.kind) \(target.displayName)"
        } else {
            description = target.displayName
        }
		
//		var config: XcodeExtraConfig? = nil
//		do {
//			let configFile = context.xcodeProject.directory.appending(subpath: "config.json")
//			let configData = try Data(contentsOf: .init(filePath: configFile.string))
//			config = try JSONDecoder().decode(XcodeExtraConfig.self, from: configData)
//		} catch _ {}
		
		var arguments: [CustomStringConvertible] = [
			"json",
			input,
			rswiftPath.string,
//			python_stdlib,
//			python_extra
		]
//		if let site_path = config?.python_site_path {
//			arguments.append("--site \(site_path)")
//		}
        return [
			.buildCommand(
			displayName: "Swiftonize(\(description))",
			executable: SwiftonizeExec,
			arguments: arguments,
			outputFiles: outputFiles
			)
        ]
    }
    
}

#endif

extension SwiftonizeBuilder {
    /// Shared function that returns a configured build command if the input files is one that should be processed.
    func createBuildCommand(for inputPath: Path, in outputDirectoryPath: Path, with generatorToolPath: Path) -> Command? {
        // Skip any file that doesn't have the extension we're looking for (replace this with the actual one).
        //guard inputPath.extension == "my-input-suffix" else { return .none }
        
        // Return a command that will run during the build to generate the output file.
		print("####### createBuildCommand ########")
        let inputName = inputPath.lastComponent
        let outputName = inputPath.stem + ".swift"
        let outputPath = outputDirectoryPath.appending(outputName)
        return .buildCommand(
            displayName: "Generating \(outputName) from \(inputName)",
            executable: generatorToolPath,
            arguments: ["\(inputPath)", "-o", "\(outputPath)"],
            inputFiles: [inputPath],
            outputFiles: [outputPath]
        )
    }
}

