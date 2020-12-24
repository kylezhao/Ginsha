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

    public let currencies: [String:String]

    init?(jsonDictionary: [String: Any]) {

        guard let modelType = ModelType(rawValue: jsonDictionary["modelType"] as! String),
              modelType == SupportedCurrenciesResult.modelType else {
            logCoreError("modelType does not match \(SupportedCurrenciesResult.modelType) for \(jsonDictionary)")
            return nil
        }

        guard let currencies = jsonDictionary["currencies"] as? [String:String] else {
            logCoreError("Failed parse currencies parameter for \(jsonDictionary)")
            return nil
        }

        _jsonDictionary = jsonDictionary
        self.currencies = currencies
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " timestamp:\(timestamp)"
            description += " validity:\(validity)"
            description += " currencies:\(currencies)"
            return description
        }
    }
}
