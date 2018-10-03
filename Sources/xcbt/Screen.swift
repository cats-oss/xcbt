//
//  Screen.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

final class Screen {
    init() {}

    func show(cache: Cache, showAll: Bool) throws {
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

        if showAll {
            sorted.forEach { showElement($0) }
        } else {
            showElement(element)
        }
    }

    private func showElement(_ element: Element) {
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

            -a --all            Show all build time of specified project (that contained in Cache.db)

            If you use below options, do not set [PROJECT_NAME].

            -l --last           Show build time of last built project
            -p --path [PATH]    Show build time of specified path
            --help              Show help

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
