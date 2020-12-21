//
//  Models.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

public class Command : CustomStringConvertible {

    let handler: (Result?) -> Void
    var path: String? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    public init(handler: @escaping (Result?) -> Void) {
        self.handler = handler
    }

    func result(with jsonDictionary: [String: Any]) -> Result? {
        logCoreError("Called abstract method on abstract base class")
        fatalError()
    }

    public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}

public class Result : CustomStringConvertible {
    public var description: String {
        get {
            return "<\(NSStringFromClass(type(of: self))):\(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}
