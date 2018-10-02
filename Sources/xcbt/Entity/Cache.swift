//
//  Cache.swift
//  xcbt
//
//  Created by marty-suzuki on 2018/10/02.
//

import Foundation

struct Cache {
    let logs: [String: Log]
    let logFormatVersion: Int
}

extension Cache: Decodable {
    private enum CodingKeys: String, CodingKey {
        case logs
        case logFormatVersion
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logs = try container.decode([String: Cache.Log].self, forKey: .logs)
        self.logFormatVersion = try container.decode(Int.self, forKey: .logFormatVersion)
    }
}

extension Cache {
    struct Log: Decodable {
        let timeStartedRecording: TimeInterval
        let timeStoppedRecording: TimeInterval
        let domainType: String
        let title: String
        let signature: String
        let schemeIdentifierSchemeName: String
        let schemeIdentifierContainerName: String
        let schemeIdentifierSharedScheme: Int
        let documentTypeString: String?
        let highLevelStatus: String

        private enum CodingKeys: String, CodingKey {
            case timeStartedRecording
            case timeStoppedRecording
            case domainType
            case title
            case signature
            case schemeIdentifierSchemeName = "schemeIdentifier-schemeName"
            case schemeIdentifierContainerName = "schemeIdentifier-containerName"
            case schemeIdentifierSharedScheme = "schemeIdentifier-sharedScheme"
            case documentTypeString
            case highLevelStatus
        }
    }
}
