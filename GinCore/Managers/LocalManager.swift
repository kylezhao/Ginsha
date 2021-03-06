//
//  LocalManager.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

import Foundation

class LocalManager: DataManaging {

    private var localCache: [String: Result] = [:]

    private let cacheURL: URL

    init() {
        cacheURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let urls = try FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options:[])
            logCore("Found cached items\(urls)")

            for url in urls {
                guard let jsonDictionary = NSDictionary(contentsOf: url) as? [String: Any] else {
                    logCoreError("Failed create jsonDictionary from data at \(url)")
                    continue
                }

                guard let result = Result.result(jsonDictionary: jsonDictionary) else {
                    logCoreError("Failed Result from jsonDictionary \(jsonDictionary)")
                    continue
                }

                let cacheKey = url.deletingPathExtension().lastPathComponent

                localCache[cacheKey] = result
                logCore("Successfully loaded \(cacheKey):\(result)")
            }

        } catch {
            logCoreError("Tried to cached results from \(cacheURL)")
        }
    }

    func save() {
        for (cacheKey, result) in localCache {
            logCore("Saving: \(cacheKey) \(result)")
            let path = cacheURL.appendingPathComponent("\(cacheKey).plist")
            NSDictionary(dictionary: result.jsonDictionary).write(to: path, atomically: true)
        }
    }

    func cache(result:Result, for command:Command) {
        logCore("\(result) \(command)")
        if IS_CURRENCY_LAYER_FREE_TRIAL && command is QuotesCommand {
            localCache["USD"] = result
        } else {
            localCache[command.cacheKey] = result
        }
    }

    // MARK: - DataManaging

    func perform(command: Command) {
        logCore("\(command)")
        if IS_CURRENCY_LAYER_FREE_TRIAL,
           let quotesCommand = command as? QuotesCommand,
           let result = localCache["USD"] {
            logCore("Creating new QuotesResult for currency \(quotesCommand.source) using previous result")
            command.handler(command.result(with: result.jsonDictionary))
        } else {
            command.handler(localCache[command.cacheKey])
        }
    }
}

