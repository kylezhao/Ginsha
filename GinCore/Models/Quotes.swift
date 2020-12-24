//
//  Quotes.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/21/20.
//

public class QuotesCommand: Command {
    
    override class var modelType: ModelType { return .Quotes }
    override var path: String { return "/live" }
    override var cacheKey: String { return source }
    
    override var queryItems: [URLQueryItem]? {
        // Only set the query if our subscription supports currency switching 
        return IS_CURRENCY_LAYER_FREE_TRIAL ? nil : [URLQueryItem(name: "source", value: source) ]
    }
    
    public let source: String
    public init(source: String, handler: @escaping (Result?) -> Void) {
        self.source = source
        super.init(handler: handler)
    }
    
    override func result(with jsonDictionary: [String: Any]) -> Result? {
        var jsonDictionary = jsonDictionary
        jsonDictionary["modelType"] = QuotesCommand.modelType.rawValue
        jsonDictionary["source"] = self.source // Override the default Source USD
        return QuotesResult(jsonDictionary: jsonDictionary)
    }
    
    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " source:\(source))"
            return description
        }
    }
}

public class QuotesResult: Result {
    
    override class var modelType: ModelType { return .Quotes }
    private let _jsonDictionary: [String: Any]
    override var jsonDictionary: [String: Any] { return _jsonDictionary }
    
    public let source: String
    public let quotes : [String:Double]
    public let sortedSymbolArray: [String]
    
    init?(jsonDictionary: [String: Any]) {
        
        guard let modelType = ModelType(rawValue: jsonDictionary["modelType"] as! String),
              modelType == QuotesResult.modelType else {
            logCoreError("modelType does not match \(QuotesResult.modelType) for \(jsonDictionary)")
            return nil
        }
        
        guard let source = jsonDictionary["source"] as? String else {
            logCoreError("Failed parse source parameter for \(jsonDictionary)")
            return nil
        }
        
        guard var quotes = jsonDictionary["quotes"] as? [String:Double] else {
            logCoreError("Failed parse quotes parameter for \(jsonDictionary)")
            return nil
        }
        
        _jsonDictionary = jsonDictionary
        self.source = source
        
        quotes = quotes.compactMapKeys { String($0.dropFirst(3)) }
        
        // Since the free subscription doesn't allow currency switching, bias the USD results with the source currency.
        if IS_CURRENCY_LAYER_FREE_TRIAL && source != "USD" {
            let sourceValue = quotes[source]!
            self.quotes = quotes.mapValues { $0 / sourceValue }
        } else {
            self.quotes = quotes
        }
        
        self.sortedSymbolArray = self.quotes.keys.sorted()
    }
    
    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " timestamp:\(timestamp)"
            description += " validity:\(validity)"
            description += " source:\(source)"
            description += " quotes:\(quotes)"
            return description
        }
    }
}

fileprivate extension Dictionary {
    // Source https://forums.swift.org/t/mapping-dictionary-keys/15342
    func compactMapKeys<T>(_ transform: ((Key) throws -> T?)) rethrows -> Dictionary<T, Value> {
        return try self.reduce(into: [T: Value](), { (result, x) in
            if let key = try transform(x.key) {
                result[key] = x.value
            }
        })
    }
}
