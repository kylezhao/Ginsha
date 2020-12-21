//
//  MainTableViewController.swift
//  Ginsha
//
//  Created by Kyle Zhao on 12/20/20.
//

import UIKit
import GinCore

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

}

