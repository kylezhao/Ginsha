//
//  QuotesTests.swift
//  GinCoreTests
//
//  Created by Kyle Zhao on 12/24/20.
//

import XCTest

@testable import GinCore

class QuotesTests: XCTestCase {

    func testCreateQuotes() throws {
        let jsonDictionary: [String: Any] = [
            "modelType" : QuotesResult.modelType.rawValue,
            "timestamp" : 1608815646,
            "source" : "USD",
            "quotes" : [
                "USDCAD" : 78.98,
                "USDJPY" : 12.34,
                "USDCNY" : 34.56,
            ]
        ]
        let result = QuotesResult(jsonDictionary: jsonDictionary)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.sortedSymbolArray, ["CAD", "CNY", "JPY"])
        XCTAssertEqual(result!.quotes, [
            "CAD" : 78.98,
            "JPY" : 12.34,
            "CNY" : 34.56,
        ])
    }

    func testCreateQuotesFail() throws {
        let jsonDictionary: [String: Any] = [
            "timestamp" : 1608815646,
            "source" : "USD",
            "quotes" : [
                "USDCAD" : 78.98,
                "USDJPY" : 12.34,
                "USDCNY" : 34.56,
            ]
        ]
        let result = QuotesResult(jsonDictionary: jsonDictionary)
        XCTAssertNil(result)
    }
}





