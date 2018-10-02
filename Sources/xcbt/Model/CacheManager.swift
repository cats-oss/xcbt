//
//  CacheManager.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

final class CacheManager {

    private let fileManager: FileManager
    private let derivedDataDir: String

    private let workingDir = "/usr/local/etc/xcbt"
    private let dbPath = "/Logs/Build/Cache.db"

    var cacheJsonPath: String {
        return workingDir + "/" + "Cache.json"
    }

    init(derivedDataDir: String = NSHomeDirectory() + "/Library/Developer/Xcode/DerivedData",
         fileManager: FileManager = .default) {
        self.derivedDataDir = derivedDataDir
        self.fileManager = fileManager
    }

    func cachedbPathFor(appName: String?) throws -> String {
        let contents = try fileManager.contentsOfDirectory(atPath: derivedDataDir)

        let dirs = contents.compactMap { content -> Directory? in
            if let appName = appName, !content.contains(appName) {
                return nil
            }
            if content.contains("ModuleCache") || content.contains(".DS_Store") {
                return nil
            }

            let attributes: [FileAttributeKey : Any]
            do {
                let filePath = derivedDataDir + "/" + content
                attributes = try fileManager.attributesOfItem(atPath: filePath)
            } catch _ {
                return nil
            }

            guard fileManager.fileExists(atPath: derivedDataDir + "/" + content + dbPath) else {
                return nil
            }

            let date = attributes.lazy.compactMap { arg -> Date? in
                guard arg.key == .modificationDate else {
                    return nil
                }
                return arg.value as? Date
            }.first

            return date.map { Directory(name: content, created: $0) }
        }

        guard let name = dirs.sorted(by: { $0.created > $1.created }).first?.name else {
            throw Error.noName(appName: appName, dirPath: derivedDataDir)
        }
        return derivedDataDir + "/" + name + dbPath
    }

    func cachedbPathFor(path: String) throws -> String {
        let fixedPath: String
        if path.hasPrefix("~/") {
            fixedPath = path.replacingOccurrences(of: "~/", with: NSHomeDirectory() + "/")
        } else {
            fixedPath = path
        }

        let filePath = fixedPath + dbPath
        guard fileManager.fileExists(atPath: filePath) else {
            throw Error.fileNotFound(path: path)
        }
        return filePath
    }

    func createWorkingDirectoryIfNeeded() throws {
        if fileManager.fileExists(atPath: workingDir) {
            return
        }
        try fileManager.createDirectory(atPath: workingDir,
                                        withIntermediateDirectories: true,
                                        attributes: [.posixPermissions: 0o755])
    }

    func locadCache() throws -> Cache {
        let url = URL(fileURLWithPath: cacheJsonPath)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Cache.self, from: data)
    }
}

extension CacheManager {
    enum Error: Swift.Error {
        case noName(appName: String?, dirPath: String)
        case fileNotFound(path: String)
    }
}

extension CacheManager.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .noName(appName?, dirPath):
            return "\"\(appName)\" not found in \(dirPath)"
        case let .noName(_, dirPath):
            return "Latest build not found in \(dirPath)"
        case let .fileNotFound(path):
            return "\"\(path)\" not found"
        }
    }
}
