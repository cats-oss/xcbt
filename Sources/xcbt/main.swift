import Foundation


private let cacheManager = CacheManager()
private let command = PlutilCommand()
private let screen = Screen()

do {
    let argument = try ArgumentParser(arguments: CommandLine.arguments)

    if case .help = argument.command {
        screen.showHelp()
        exit(0)
    }

    try cacheManager.createWorkingDirectoryIfNeeded()

    let cachedbPath: String
    let showAll: Bool
    if case let .custom(path) = argument.command {
        cachedbPath = try cacheManager.cachedbPathFor(path: path)
        showAll = false
    } else {
        let info = argument.displayInfo
        cachedbPath = try cacheManager.cachedbPathFor(appName: info?.appName)
        showAll = info?.showAll ?? false
    }
    try command.execute(binaryPath: cachedbPath, jsonPath: cacheManager.cacheJsonPath)

    let cache = try cacheManager.locadCache()
    try screen.show(cache: cache, showAll: showAll)
} catch {
    print(error.localizedDescription)
}
