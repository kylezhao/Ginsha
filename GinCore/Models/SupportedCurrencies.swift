//
//  SupportedCurrencies.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/21/20.
//

public class SupportedCurrenciesCommand: Command {
    override var path: String? { return "/list" }

    override func result(with jsonDictionary: [String: Any]) -> Result? {
        return SupportedCurrenciesResult(for: jsonDictionary)
    }

    override public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}

public class SupportedCurrenciesResult: Result {
    let currencies : [String:String]

    init?(for jsonDictionary: [String: Any]) {

        guard let currencies = jsonDictionary["currencies"] as? [String:String] else {
            logCoreError("Failed parse currencies parameter for \(jsonDictionary)")
            return nil
        }

        self.currencies = currencies
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " currencies:\(currencies)"
            return description
        }
    }
}
