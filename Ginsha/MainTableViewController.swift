//
//  MainTableViewController.swift
//  Ginsha
//
//  Created by Kyle Zhao on 12/20/20.
//

import UIKit
import GinCore

class MainTableViewController: UITableViewController {

    private let currencyCellID = "currencyCell"
    private let amountCellID = "amountCell"
    private var currencySelectionViewController: CurrencySelectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencySelectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CurrencySelectionViewController") as? CurrencySelectionViewController
        self.currencySelectionViewController.selectionHandler = { (currency: String) in
            logApp("currency selected \(currency)")
            GinManager.shared.save()
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.present(currencySelectionViewController, animated: true, completion: nil)
    }


    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row == 0 ? currencyCellID : amountCellID, for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return NSLocalizedString("Convert From", comment: "Header text above conversion source currency symbol and conversion amount")
        } else {
            return NSLocalizedString("Convert To", comment: "conversion destination currencies")
        }
    }
}

