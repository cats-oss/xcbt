//
//  Screen.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

final class Screen {
    init() {}

    func show(cache: Cache) throws {
        let elements = cache.logs.map {
            Element(start: Date(timeIntervalSinceReferenceDate: $0.value.timeStartedRecording),
                    end: Date(timeIntervalSinceReferenceDate: $0.value.timeStoppedRecording),
                    title: $0.value.title.split(separator: " ").first.map(String.init) ?? "unknown",
                    schemeName: $0.value.schemeIdentifierSchemeName)
        }

        let sorted = elements.sorted { $0.start > $1.start }

        guard let element = sorted.first else {
            throw Error.elementNotFound
        }

        let title = element.title
        print("""
        Scheme: \(element.schemeName)

            - \(title) start : \(element.start)
            - \(title) end   : \(element.end)
            - \(title) time  : \(String(format: "%.4lf", element.time))s
        """)
    }

    func showHelp() {
        print("""
        Usage:

            $ xcbt [PROJECT_NAME]

            Xcode Build Time

        Options:

            -l --last           Show build time of last built project
            -p --path [PATH]    Show build time of specified path
            --help              Show help

            If you use options, do not set [PROJECT_NAME].

        """)
    }
}

extension Screen {
    struct Element {
        let start: Date
        let end: Date
        let title: String
        let schemeName: String
    }

    enum Error: Swift.Error {
        case elementNotFound
    }
}

extension Screen.Element {
    var time: TimeInterval {
        return end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
}
