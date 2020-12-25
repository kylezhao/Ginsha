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


    func testSupportedCurrenciesCommandEmptyCache() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = SupportedCurrenciesCommand() { (result) in
            handlerExpectation.fulfill()
            XCTAssertNil(result)
        }
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPermorQuotesCommandEmptyCache() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = QuotesCommand(source: "USD") { (result) in
            handlerExpectation.fulfill()
            XCTAssertNil(result)
        }
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformSupportedCurrenciesCommandCachedResult() throws {

        let jsonDictionary: [String : Any] = [
            "modelType" : SupportedCurrenciesResult.modelType.rawValue,
            "currencies" : ["USD" : "United States Dollar"]
        ]

        let result = SupportedCurrenciesResult(jsonDictionary: jsonDictionary)
        XCTAssertNotNil(result)

        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = SupportedCurrenciesCommand() { (result) in
            handlerExpectation.fulfill()
            XCTAssertNotNil(result)
        }

        localManager.cache(result: result!, for: command)
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPermorQuotesCommandCachedResult() throws {

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

        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = QuotesCommand(source: "JPY") { (result) in
            handlerExpectation.fulfill()
            XCTAssertNotNil(result)
        }

        localManager.cache(result: result!, for: command)
        localManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }
}

