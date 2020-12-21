//
//  Convert.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/21/20.
//

public class ConvertCommand: Command {
    public let source: String
    public let destination: String
    public let amount: Double

    override var path: String? { return "/convert" }
    override var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "from", value: source),
            URLQueryItem(name: "to", value: destination),
            URLQueryItem(name: "amount", value: String(amount))
        ]
    }

    public init(source: String, destination: String, amount: Double, handler: @escaping (Result?) -> Void) {
        self.source = source
        self.destination = destination
        self.amount = amount
        super.init(handler: handler)
    }

    override func result(with jsonDictionary: [String: Any]) -> Result? {
        return ConvertResult(for: jsonDictionary)
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " source:\(source)"
            description += " destination:\(destination)"
            description += " amount:\(amount))"
            return description
        }
    }
}

public class ConvertResult: Result {

    public let timestamp: TimeInterval
    public let source: String
    public let destination: String
    public let amount: Double
    public let result: Double
    public let quote: Double

    init?(for jsonDictionary: [String: Any]) {

        guard let query = jsonDictionary["query"] as? [String:Any],
              let source = query["from"] as? String,
              let destination = query["to"] as? String,
              let amount = query["amount"] as? Double else {
            logCoreError("Failed parse query parameter for \(jsonDictionary)")
            return nil
        }

        guard let info = jsonDictionary["info"] as? [String:Any],
              let timestamp = info["timestamp"] as? TimeInterval,
              let quote = info["quote"] as? Double else {
            logCoreError("Failed parse info parameter for \(jsonDictionary)")
            return nil
        }

        guard let result = jsonDictionary["result"] as? Double else {
            logCoreError("Failed parse result parameter for \(jsonDictionary)")
            return nil
        }

        self.timestamp = timestamp
        self.source = source
        self.destination = destination
        self.amount = amount
        self.result = result
        self.quote = quote
    }

    override public var description: String {
        get {
            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
            description += " source:\(source)"
            description += " destination:\(destination)"
            description += " amount:\(amount))"

            description += " timestamp:\(timestamp)"
            description += " source:\(source)"
            description += " destination:\(destination)"
            description += " amount:\(amount)"
            description += " result:\(result)"
            description += " quote:\(quote)"

            return description

        }
    }
}
