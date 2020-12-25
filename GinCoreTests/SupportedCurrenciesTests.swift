//
//  SupportedCurrenciesTests.swift
//  GinCoreTests
//
//  Created by Kyle Zhao on 12/24/20.
//

import XCTest

@testable import GinCore

class SupportedCurrenciesTests: XCTestCase {

    func testCreateSupportedCurrencies() throws {
        let jsonDictionary: [String : Any] = [
            "modelType" : SupportedCurrenciesResult.modelType.rawValue,
            "currencies" : [
                "USD" : "United States Dollar",
                "JPY" : "Japanese Yen",
                "CNY" : "Chinese Yuan",
                "CAD" : "Canadian Dollar",
            ]
        ]

        let result = SupportedCurrenciesResult(jsonDictionary: jsonDictionary)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.sortedSymbolArray, ["CAD", "CNY", "JPY", "USD"])
        XCTAssertEqual(result!.sortedPrefixArray, ["C", "J", "U"])
        XCTAssertEqual(result!.prefixToSymbolsDictionary, ["C" : ["CAD", "CNY"], "J":["JPY"], "U":["USD"]])
        XCTAssertEqual(result!.symbolToNameDictionary, [
            "USD" : "United States Dollar",
            "JPY" : "Japanese Yen",
            "CNY" : "Chinese Yuan",
            "CAD" : "Canadian Dollar",
        ])
    }

    func testCreateSupportedCurrenciesCreationFail() throws {
        let jsonDictionary: [String : Any] = [
            "modelType" : QuotesCommand.modelType.rawValue, // The model type is mismatched
            "currencies" : [
                "USD" : "United States Dollar",
                "JPY" : "Japanese Yen",
                "CNY" : "Chinese Yuan",
                "CAD" : "Canadian Dollar",
            ]
        ]

        let result = SupportedCurrenciesResult(jsonDictionary: jsonDictionary)
        XCTAssertNil(result)
    }
}
