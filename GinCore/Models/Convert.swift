////
////  Convert.swift
////  GinCore
////
////  Created by Kyle Zhao on 12/21/20.
////
//
//public class ConvertCommand: Command {
//    public let source: String
//    public let destination: String
//    public let amount: Double
//
//    override var path: String? { return "/convert" }
//    override var cacheKey: String { return "\(source)\(destination)" }
//    override var queryItems: [URLQueryItem]? {
//        return [
//            URLQueryItem(name: "from", value: source),
//            URLQueryItem(name: "to", value: destination),
//            URLQueryItem(name: "amount", value: String(amount))
//        ]
//    }
//
//    public init(source: String, destination: String, amount: Double, handler: @escaping (Result?) -> Void) {
//        self.source = source
//        self.destination = destination
//        self.amount = amount
//        super.init(handler: handler)
//    }
//
//    private var _result: Result?
//    override public var result: Result? {
//        if _result != nil {
//            return _result!
//        } else  {
//            guard let jsonDictionary = self.jsonDictionary else { return nil }
//            _result = ConvertResult(for: jsonDictionary)
//            return _result!
//        }
//    }
//
//    override public var description: String {
//        get {
//            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
//            description += " source:\(source)"
//            description += " destination:\(destination)"
//            description += " amount:\(amount))"
//            return description
//        }
//    }
//}
//
//public class ConvertResult: Result {
//
//    private let _timestamp: TimeInterval
//    override public var timestamp: TimeInterval {
//        return _timestamp
//    }
//    public let source: String
//    public let destination: String
//    public let amount: Double
//    public let result: Double
//    public let quote: Double
//
//    init?(for jsonDictionary: [String: Any]) {
//
//        guard let query = jsonDictionary["query"] as? [String:Any],
//              let source = query["from"] as? String,
//              let destination = query["to"] as? String,
//              let amount = query["amount"] as? Double else {
//            logCoreError("Failed parse query parameter for \(jsonDictionary)")
//            return nil
//        }
//
//        guard let info = jsonDictionary["info"] as? [String:Any],
//              let timestamp = info["timestamp"] as? TimeInterval,
//              let quote = info["quote"] as? Double else {
//            logCoreError("Failed parse info parameter for \(jsonDictionary)")
//            return nil
//        }
//
//        guard let result = jsonDictionary["result"] as? Double else {
//            logCoreError("Failed parse result parameter for \(jsonDictionary)")
//            return nil
//        }
//
//        self._timestamp = timestamp
//        self.source = source
//        self.destination = destination
//        self.amount = amount
//        self.result = result
//        self.quote = quote
//        super.init()
//    }
//
//    override public var description: String {
//        get {
//            var description = "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
//            description += " timestamp:\(timestamp)"
//            description += " validity:\(validity)"
//            description += " source:\(source)"
//            description += " destination:\(destination)"
//            description += " amount:\(amount)"
//            description += " result:\(result)"
//            description += " quote:\(quote)"
//
//            return description
//        }
//    }
//}
