//
//  NetworkManagerTests.swift
//  GinCoreTests
//
//  Created by Kyle Zhao on 12/24/20.
//

import XCTest

@testable import GinCore

class NetworkManagerTests: XCTestCase {

    let networkManager = NetworkManager()

    func testPermorQuotesCommand() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = QuotesCommand(source: "USD") { (result) in
            handlerExpectation.fulfill()
            XCTAssertNotNil(result)
        }
        networkManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }


    func testPerformSupportedCurrenciesCommand() throws {
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        let command = SupportedCurrenciesCommand() { (result) in
            handlerExpectation.fulfill()
            XCTAssertNotNil(result)
        }
        networkManager.perform(command: command)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
