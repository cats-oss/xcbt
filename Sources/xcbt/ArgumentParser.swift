//
//  ArgumentParser.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

final class ArgumentParser {
    let command: Command

    init(arguments: [String]) throws {
        switch arguments.count {
        case 2:
            switch arguments[1] {
            case "--help":
                self.command = .help

            case "-l", "--last":
                self.command = .last

            default:
                self.command = .default(appName: arguments[1])
            }

        case 3 where arguments[1] == "-p" || arguments[1] == "--path":
            self.command = .custom(path: arguments[2])

        default:
            self.command = .help
        }
    }
}

extension ArgumentParser {
    enum Command {
        case `default`(appName: String)
        case custom(path: String)
        case help
        case last
    }

    var appName: String? {
        switch command {
        case let .default(appName):
            return appName
        case .help, .last, .custom:
            return nil
        }
    }
}
