//
//  CurrencySelectionViewControllerTests.swift
//  GinshaTests
//
//  Created by Kyle Zhao on 12/24/20.
//

import XCTest
@testable import GinCore
@testable import Ginsha

class CurrencySelectionViewControllerTests: XCTestCase {

    let result = SupportedCurrenciesResult(jsonDictionary: [
        "modelType" : SupportedCurrenciesResult.modelType.rawValue,
        "currencies" : [
            "USD" : "United States Dollar",
            "JPY" : "Japanese Yen",
            "CNY" : "Chinese Yuan",
            "CAD" : "Canadian Dollar",
        ]
    ])

    func testSelectingCurrency() throws {
        let currencySelectionViewController = CurrencySelectionViewController()
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        currencySelectionViewController.selectionHandler = { (currency: String, name: String) in
            handlerExpectation.fulfill()

            XCTAssertEqual(currency, "CAD")
            XCTAssertEqual(name, NSLocalizedString("Canadian Dollar", comment: "testing"))
        }
        currencySelectionViewController.supportedCurrenciesResult = result
        currencySelectionViewController.tableView(currencySelectionViewController.tableView,
                                                   didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSelectingCurrency2() throws {
        let currencySelectionViewController = CurrencySelectionViewController()
        let handlerExpectation = self.expectation(description: "handlerExpectation")
        currencySelectionViewController.selectionHandler = { (currency: String, name: String) in
            handlerExpectation.fulfill()

            XCTAssertEqual(currency, "JPY")
            XCTAssertEqual(name, NSLocalizedString("Japanese Yen", comment: "testing"))
        }
        currencySelectionViewController.supportedCurrenciesResult = result
        currencySelectionViewController.tableView(currencySelectionViewController.tableView,
                                                   didSelectRowAt: IndexPath(row: 0, section: 1))
        waitForExpectations(timeout: 5, handler: nil)
    }
}
