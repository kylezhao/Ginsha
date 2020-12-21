//
//  Quotes.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/21/20.
//


public class QuotesCommand: Command {
    public let source: String
    override var path: String? { return "/live" }
    public init(source: String, handler: @escaping (Result?) -> Void) {
        self.source = source
        super.init(handler: handler)
    }

    override func result(with jsonDictionary: [String: Any]) -> Result? {
        return QuotesResult(for: jsonDictionary)
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
    public let timestamp: TimeInterval
    public let source: String
    public let quotes : [String:Double]

    init?(for jsonDictionary: [String: Any]) {

        guard let timestamp = jsonDictionary["timestamp"] as? TimeInterval else {
            logCoreError("Failed parse timestamp parameter for \(jsonDictionary)")
            return nil
        }

        guard let source = jsonDictionary["source"] as? String else {
            logCoreError("Failed parse source parameter for \(jsonDictionary)")
            return nil
        }

        guard let quotes = jsonDictionary["quotes"] as? [String:Double] else {
            logCoreError("Failed parse quotes parameter for \(jsonDictionary)")
            return nil
        }

        self.source = source
        self.timestamp = timestamp
        self.quotes = quotes.compactMapKeys { String($0.dropFirst(3)) }
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " source:\(source)"
            description += " timestamp:\(timestamp)"
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
