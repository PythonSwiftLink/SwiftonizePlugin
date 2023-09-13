import PackagePlugin
import Foundation
@main
struct SwiftonizeBuilder: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }

        // Find the code generator tool to run (replace this with the actual one).
        let generatorTool = try context.tool(named: "SwiftonizeBuilder")

        // Construct a build command for each source file with a particular suffix.
        return sourceFiles.map(\.path).compactMap {
            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
        }
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
            .appending(subpath: target.displayName)
            .appending(subpath: "Resources")

        try FileManager.default.createDirectory(atPath: resourcesDirectoryPath.string, withIntermediateDirectories: true)

        let rswiftPath = resourcesDirectoryPath//.appending(subpath: "R.generated.swift")
        print(input)
        print(rswiftPath)
        let outputFiles = try FileManager.default.contentsOfDirectory(atPath: input.string).map({ file -> Path in
            let _file = Path(file)
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
        return [
            
            .buildCommand(
                displayName: "Z.swift generate resources for \(description)",
                executable: try context.tool(named: "swiftonize").path,
                arguments: [
                    "generate",
                    input,
                    rswiftPath.string,
                ],
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

