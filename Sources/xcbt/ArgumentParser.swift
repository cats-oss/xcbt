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
                let info = DisplayInfo(appName: arguments[1], showAll: false)
                self.command = .default(info)
            }

        case 3 where arguments[1] == "-p" || arguments[1] == "--path":
            self.command = .custom(path: arguments[2])

        case 3 where arguments[2] == "-a" || arguments[2] == "--all":
            let info = DisplayInfo(appName: arguments[1], showAll: true)
            self.command = .default(info)

        default:
            self.command = .help
        }
    }
}

extension ArgumentParser {
    enum Command {
        case `default`(DisplayInfo)
        case custom(path: String)
        case help
        case last
    }

    var displayInfo: DisplayInfo? {
        switch command {
        case let .default(displayInfo):
            return displayInfo
        case .help, .last, .custom:
            return nil
        }
    }

    struct DisplayInfo {
        let appName: String
        let showAll: Bool
    }
}
