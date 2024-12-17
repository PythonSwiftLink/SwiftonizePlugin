//
//  File.swift
//  SwiftonizePlugin
//
//  Created by CodeBuilder on 17/12/2024.
//

import Foundation
import PackagePlugin

enum SwiftonizeError: Error {
    case fileNotFound(path: String)
    case swiftonizeNotFound(URL)
}

fileprivate func pathsToAdd() -> [String] {[
    "/usr/local/bin",
    "/opt/homebrew/bin"
]}

extension String {
    mutating func extendedPath() {
        self += ":\(pathsToAdd().joined(separator: ":"))"
    }
    mutating func strip() {
        self.removeLast(1)
    }
}

func which_swiftonize() throws -> Path {
    let proc = Process()
    //proc.executableURL = .init(filePath: "/bin/zsh")
    proc.executableURL = .init(filePath: "/usr/bin/which")
    proc.arguments = ["pstoolchain"]
    let pipe = Pipe()
    
    proc.standardOutput = pipe
    var env = ProcessInfo.processInfo.environment
    env["PATH"]?.extendedPath()
    proc.environment = env
    
    try! proc.run()
    proc.waitUntilExit()
    
    guard
        let data = try? pipe.fileHandleForReading.readToEnd(),
        var path = String(data: data, encoding: .utf8)
    else { throw SwiftonizeError.swiftonizeNotFound(.init(string: "https://discord.com/channels/913144015044636702/1299787815747584062")!) }
    path.strip()
    return .init(path)
}


func processInputFiles(input: Path, root: Path) throws -> [Path] {
    try FileManager.default.contentsOfDirectory(atPath: input.string).compactMap({ file -> Path? in
        let _file = Path(file)
        if _file.lastComponent == ".DS_Store" { return nil }
        let name = _file.stem
        return root.appending(subpath: "\(name).swift")
    })
}

extension Command {
    static func swiftonize(input: Path, context: PluginContext) throws -> Self {
        let arguments: [CustomStringConvertible] = [
            "swiftonize",
            "build",
            input,
            context.pluginWorkDirectory,
        ]
        return .buildCommand(
            displayName: "Swiftonize(\(context.package.displayName))",
            executable: try which_swiftonize(),
            arguments: arguments,
            outputFiles: try processInputFiles(input: input, root: context.pluginWorkDirectory)
        )
    }
}
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
extension Command {
    static func swiftonize(input: Path, context: XcodePluginContext, target: XcodeTarget) throws -> Self {
        let description: String = if let product = target.product {
            "\(product.kind) \(target.displayName)"
        } else {
            target.displayName
        }
        let resourcesDirectoryPath = context.pluginWorkDirectory
        
        let arguments: [CustomStringConvertible] = [
            "swiftonize",
            "build",
            input,
            resourcesDirectoryPath,
        ]
        return .buildCommand(
            displayName: "Swiftonize(\(description))",
            executable: try which_swiftonize(),
            arguments: arguments,
            outputFiles: try processInputFiles(input: input, root: resourcesDirectoryPath)
        )
    }
}
#endif

