//
//  LocalManagerTests.swift
//  GinCoreTests
//
//  Created by Kyle Zhao on 12/24/20.
//

import XCTest

@testable import GinCore

class LocalManagerTests: XCTestCase {

    let localManager = LocalManager()

    func testPermorQuotesCommandEmptyCache() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = QuotesCommand(source: "USD") { (result) in
            handlerExpectation.fulfill()
            XCTAssertNil(result)
        }
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSupportedCurrenciesCommandEmptyCache() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = SupportedCurrenciesCommand() { (result) in
            handlerExpectation.fulfill()
            XCTAssertNil(result)
        }
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformQuotesCommandCachedResult() throws {
        let jsonDictionary: [String: Any ] = [
            "timestamp" : 1608815646,
            "modelType" : QuotesResult.modelType.rawValue,
            "source" :  "USD",
            "quotes" : [
                "USDLAK" : 9288.789745,
                "USDUZS" : 10478.061542,
                "USDKWD" : 0.305403,
                "USDISK" : 127.870084,
                "USDEGP" : 15.733302,
                "USDSGD" : 1.328202,
                "USDCNY" : 6.5301,
            ]
        ]

        let result = QuotesResult(jsonDictionary: jsonDictionary)
        XCTAssertNotNil(result)

        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = QuotesCommand(source: "CNY") { (result) in
            handlerExpectation.fulfill()
            XCTAssertNotNil(result)
        }

        localManager.cache(result: result!, for: command)
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
