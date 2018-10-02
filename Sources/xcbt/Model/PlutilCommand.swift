//
//  PlutilCommand.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

final class PlutilCommand {
    private let executableURL = URL(fileURLWithPath: "/usr/bin/plutil")

    init() {}

    func execute(binaryPath: String, jsonPath: String) throws {
        let arguments = ["-convert", "json", "-r", binaryPath, "-o", jsonPath]
        let process = Process()
        if #available(OSX 10.13, *) {
            process.executableURL = executableURL
            process.arguments = arguments
            try process.run()
        } else {
            process.launchPath = executableURL.absoluteString
            process.arguments = arguments
            process.launch()
        }
        process.waitUntilExit()

        if process.terminationReason == .uncaughtSignal {
            throw Error.uncaughtSignal
        }
    }
}

extension PlutilCommand {
    enum Error: Swift.Error {
        case uncaughtSignal
    }
}
