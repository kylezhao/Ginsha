//
//  GinManager.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

import Foundation

public class GinManager: DataManaging {

    public static let shared = GinManager()

    private let localManager: LocalManager = LocalManager()
    private let networkManager: NetworkManager = NetworkManager()

    public func save() {
        localManager.save()
    }

    // MARK: - DataManaging

    public func perform(command: Command) {
        performLocal(command: command)
    }

    // MARK: - Private Methods

    private func performLocal(command: Command) {

        logCore("\(command)")

        let originalHandler = command.handler

        command.handler = { [weak self] (localResult: Result?) in
            guard let self = self else { return }
            
            if let result = localResult {
                if result.validity == .valid {
                    logCore("Found valid local \(result)")
                    originalHandler(result)
                    return
                }

                logCore("Found expired local \(result)")

            } else {
                logCore("No cached results")
            }
            
            command.handler = originalHandler
            self.performNetwork(command: command, localResult: localResult)
        }

        localManager.perform(command: command)
    }

    private func performNetwork(command: Command, localResult: Result?) {

        logCore("\(command)")

        let originalHandler = command.handler

        command.handler = { [weak self] (networkResult: Result?) in
            guard let self = self else { return }

            if let result = networkResult {
                logCore("Fetched new result from network \(result)")
                originalHandler(result)
                self.localManager.cache(result: result, for: command)
                return
            }

            if let result = localResult {
                logCore("Failed to get network result, falling back to an expired local result \(result)")
                originalHandler(result)
                return
            }

            logCore("Failed to fetch from local and network for \(command)")
            originalHandler(nil)
        }
        networkManager.perform(command: command)
    }
}


/*
 let supportedCurrenciesCommand = SupportedCurrenciesCommand { (resultOptional: Result?) in

 guard let result = resultOptional else {
 logAppError("got nil result for command")
 return
 }

 guard let supportedCurrenciesResult = result as? SupportedCurrenciesResult else {
 logAppError("failed to cast \(result) as SupportedCurrenciesResult")
 return
 }

 logApp("success got \(supportedCurrenciesResult)")
 }

 GinManager.shared.perform(command: supportedCurrenciesCommand)



 let quotesCommand = QuotesCommand(source: "USD") { (resultOptional: Result?) in

 guard let result = resultOptional else {
 logAppError("got nil result for command")
 return
 }

 guard let quotesResult = result as? QuotesResult else {
 logAppError("failed to cast \(result) as QuotesResult")
 return
 }

 logApp("success got \(quotesResult)")
 }

 GinManager.shared.perform(command: quotesCommand)


 let convertCommand = ConvertCommand(source: "USD", destination: "CNY", amount: 100) { (resultOptional: Result?) in

 guard let result = resultOptional else {
 logAppError("got nil result for command")
 return
 }

 guard let convertResult = result as? ConvertResult else {
 logAppError("failed to cast \(result) as ConvertResult")
 return
 }

 logApp("success got \(convertResult)")
 }

 GinManager.shared.perform(command: convertCommand)

 */
