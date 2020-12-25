//
//  SupportedCurrencies.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/21/20.
//

public class SupportedCurrenciesCommand: Command {

    override class var modelType: ModelType { return .SupportedCurrencies }
    override var path: String { return "/list" }
    override var cacheKey: String { return "SupportedCurrencies" }

    override func result(with jsonDictionary: [String: Any]) -> Result? {
        var jsonDictionary = jsonDictionary
        jsonDictionary["modelType"] = SupportedCurrenciesCommand.modelType.rawValue
        return SupportedCurrenciesResult(jsonDictionary: jsonDictionary)
    }

    override public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}

public class SupportedCurrenciesResult: Result {

    override class var modelType: ModelType { return .SupportedCurrencies }
    private let _jsonDictionary: [String: Any]
    override var jsonDictionary: [String: Any] { return _jsonDictionary }

    public let sortedSymbolArray: [String] // [AED, BAT]
    public let sortedPrefixArray: [String] // [A, B, C, E]
    public let prefixToSymbolsDictionary: [String: [String]] // [A:[A1, A2], B:[B1, B2]]
    public let symbolToNameDictionary: [String: String] // [JPY:"Japanese Yen"]

    init?(jsonDictionary: [String: Any]) {

        guard let rawValue = jsonDictionary["modelType"] as? String,
              let modelType = ModelType(rawValue: rawValue),
              modelType == SupportedCurrenciesResult.modelType else {
            logCoreError("modelType does not match \(SupportedCurrenciesResult.modelType) for \(jsonDictionary)")
            return nil
        }

        guard let currencies = jsonDictionary["currencies"] as? [String:String] else {
            logCoreError("Failed parse currencies parameter for \(jsonDictionary)")
            return nil
        }

        _jsonDictionary = jsonDictionary

        self.symbolToNameDictionary = currencies
        self.sortedSymbolArray = self.symbolToNameDictionary.keys.sorted()
        self.prefixToSymbolsDictionary = self.sortedSymbolArray.reduce(into: [String:[String]] ()) { collection, symbol in
            collection[String(symbol.prefix(1)), default: []].append(symbol)
        }
        self.sortedPrefixArray = self.prefixToSymbolsDictionary.keys.sorted()
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " timestamp:\(timestamp)"
            description += " validity:\(validity)"
            description += " currencies:\(symbolToNameDictionary)"
            return description
        }
    }
}
