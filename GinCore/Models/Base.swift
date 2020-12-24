//
//  Base.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

// 30 minutes
let validityTimeInterval: TimeInterval = 1800.0

enum ModelType: String {
    case SupportedCurrencies
    case Quotes
}

public class Command: CustomStringConvertible {

    class var modelType: ModelType { fatalError("Called abstract method on abstract base class") }
    var path: String { fatalError("Called abstract method on abstract base class") }
    var cacheKey: String { fatalError("Called abstract method on abstract base class") }

    var handler: (Result?) -> Void
    var queryItems: [URLQueryItem]? { return nil }

    func result(with jsonDictionary: [String: Any]) -> Result? {
        fatalError("Called abstract method on abstract base class")
    }
    
    public init(handler: @escaping (Result?) -> Void) {
        self.handler = handler
    }

    public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}

public class Result : CustomStringConvertible {

    public enum ResultValidity {
        case valid
        case expired
    }

    class var modelType: ModelType { fatalError("Called abstract method on abstract base class") }
    var jsonDictionary: [String: Any] { fatalError("Called abstract method on abstract base class") }

    private let _timestamp: TimeInterval
    var timestamp: TimeInterval { return _timestamp }


    public class func result(jsonDictionary: [String: Any]) -> Result? {
        guard let modelType = ModelType(rawValue: jsonDictionary["modelType"] as! String) else {
            logCoreError("failed to parse modelType in  \(jsonDictionary)")
            return nil
        }

        switch modelType {
        case .SupportedCurrencies:
            return SupportedCurrenciesResult(jsonDictionary: jsonDictionary)

        case .Quotes:
            return QuotesResult(jsonDictionary: jsonDictionary)
        }
    }


    public init() {
        _timestamp = Date().timeIntervalSince1970
    }

    public var validity: ResultValidity {
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = self.timestamp + validityTimeInterval
        return currentTimestamp < expiryTimestamp ? .valid : .expired
    }

    public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}
