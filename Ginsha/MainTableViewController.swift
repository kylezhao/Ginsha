//
//  MainTableViewController.swift
//  Ginsha
//
//  Created by Kyle Zhao on 12/20/20.
//

import UIKit
import GinCore

class MainTableViewController: UITableViewController, UITextFieldDelegate {
    
    private let currencyCellID = "currencyCell"
    private let amountCellID = "amountCell"
    private let resultCellID = "resultCell"
    private let quotesCellID = "quotesCell"
    private var currencySelectionViewController: CurrencySelectionViewController!
    private var symbolToNameDictionary: [String: String]?
    private var quotesResult: QuotesResult?
    private var supportedCurrenciesResult: SupportedCurrenciesResult?
    private var amountTextFeild: UITextField?
    private var resultLabel: UILabel?
    private var sourceSymbol: String?
    private var destinationSymbol: String?
    private var exchangeRate: Double? {
        didSet {
            guard let amountString = self.amountTextFeild?.text else { return }
            updateResultLabel(amountString: amountString)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
        self.title = NSLocalizedString("Cash Ninja", comment: "Title text for main table view Controller")
        self.currencySelectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CurrencySelectionViewController") as? CurrencySelectionViewController
        
        let supportedCurrenciesCommand = SupportedCurrenciesCommand { [weak self] (resultOptional: Result?) in
            guard let self = self else { return }
            
            guard let result = resultOptional else {
                logAppError("got nil result for command")
                return
            }
            
            guard let supportedCurrenciesResult = result as? SupportedCurrenciesResult else {
                fatalError("failed to cast \(result) as SupportedCurrenciesResult")
            }
            
            logApp("success got \(supportedCurrenciesResult)")
            
            self.supportedCurrenciesResult = supportedCurrenciesResult
            self.currencySelectionViewController.supportedCurrenciesResult = supportedCurrenciesResult
        }
        
        GinManager.shared.perform(command: supportedCurrenciesCommand)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        guard updatedText.count <= 20 else { return false }
        guard let resultLabel = self.resultLabel else { return true }
        
        if updatedText.count == 0 {
            resultLabel.text = "0"
            return true
        }
        
        updateResultLabel(amountString: updatedText)
        
        return true
    }
    
    private func updateResultLabel(amountString: String) {
        guard let amount = Double(amountString),
              let rate = self.exchangeRate,
              let resultLabel = self.resultLabel else { return }
        resultLabel.text = String(format: "%.3f", amount * rate)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row == 0 && (indexPath.section == 0 || indexPath.section == 1) else {
            return
        }
        
        self.navigationController?.present(currencySelectionViewController, animated: true, completion: nil)
        let cell = tableView.cellForRow(at: indexPath)
        
        self.currencySelectionViewController.selectionHandler = { (currency: String, name: String) in
            logApp("currency selected \(currency) \(name)")
            cell?.textLabel?.text = name
            cell?.detailTextLabel?.text = currency
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            if indexPath.section == 0 {
                // Selection for source currency
                self.sourceSymbol = currency
                self.fetchQuotes(currency: currency)
            } else if indexPath.section == 1 {
                // Selection for destination currency
                self.destinationSymbol = currency
                if let result = self.quotesResult {
                    self.exchangeRate = result.quotes[currency]
                    logApp("The exchangeRate is \(self.exchangeRate!) for \(result.source) to \(currency)")
                }
            }
        }
    }
    
    private func fetchQuotes(currency: String) {
        let quotesCommand = QuotesCommand(source:currency) { (resultOptional: Result?) in
            
            guard let result = resultOptional else {
                logAppError("Failed to load quotes for \(currency)")
                return
            }
            
            guard let quotesResult = result as? QuotesResult else {
                fatalError("failed to cast \(result) as QuotesResult")
            }
            
            logApp("success got \(quotesResult)")
            
            if let destinationSymbol = self.destinationSymbol {
                self.exchangeRate = quotesResult.quotes[destinationSymbol]
                logApp("The exchangeRate is \(self.exchangeRate!) for \(quotesResult.source) to \(destinationSymbol)")
            }
            
            self.tableView.beginUpdates()
            if self.quotesResult != nil {
                self.tableView.deleteSections([2], with: .top)
            }
            self.quotesResult = quotesResult
            self.tableView.insertSections([2], with: .top)
            self.tableView.endUpdates()
        }
        
        GinManager.shared.perform(command: quotesCommand)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.quotesResult == nil ? 2 : 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1 {
            return 2
        } else if section == 2, let quotsResult = self.quotesResult {
            return quotsResult.quotes.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            
            // Source Currency Cell
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: currencyCellID, for: indexPath)
                let sourceCurrencyLabel = cell.viewWithTag(1) as! UILabel
                sourceCurrencyLabel.text = NSLocalizedString("Source Currency", comment: "Placeholder text for selecting a source currency")
                
            // Source Amout Cell
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: amountCellID, for: indexPath)
                self.amountTextFeild = cell.viewWithTag(1) as? UITextField
                self.amountTextFeild?.placeholder = NSLocalizedString("Amount", comment: "Placeholder text for user entered money amount")
                self.amountTextFeild?.delegate = self
                
            default:
                fatalError("TableView requeting title for section out of bounds \(indexPath.section)")
            }
            
        case 1:
            switch indexPath.row {
            
            // Destination Currency Cell
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: currencyCellID, for: indexPath)
                let sourceCurrencyLabel = cell.viewWithTag(1) as! UILabel
                sourceCurrencyLabel.text = NSLocalizedString("Destination Currency", comment: "Placeholder text for selecting a destination currency")
                
            // Destination Amout Cell
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: resultCellID, for: indexPath)
                cell.textLabel?.text = NSLocalizedString("Converted Amount", comment: "Placeholder text for converted money amount")
                self.resultLabel = cell.textLabel
                
            default:
                fatalError("TableView requeting title for section out of bounds \(indexPath.section)")
            }
            
        // All Quotes
        case 2:
            guard let quotesResult = self.quotesResult,
                  let currenciesResult = self.supportedCurrenciesResult else {
                fatalError("Trying create cell without QuotesResult and SupportedCurrenciesResult")
            }
            cell = tableView.dequeueReusableCell(withIdentifier: quotesCellID, for: indexPath)
            
            let symbol = quotesResult.sortedSymbolArray[indexPath.row]
            let name = currenciesResult.symbolToNameDictionary[symbol]!
            let localizedname = NSLocalizedString(name, comment: "Currency Name for \(symbol)")
            let value = quotesResult.quotes[symbol]
            
            let symbolLabel = cell.viewWithTag(1) as! UILabel
            let nameLabel = cell.viewWithTag(2) as! UILabel
            let valueLabel = cell.viewWithTag(3) as! UILabel
            
            symbolLabel.text = symbol
            nameLabel.text = localizedname
            valueLabel.text = String(format: "%.3f", value!)
            
        default:
            fatalError("TableView requeting title for section out of bounds \(indexPath.section)")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return NSLocalizedString("Convert From", comment: "Header text above conversion source currency symbol and conversion amount")
            
        case 1:
            return NSLocalizedString("Convert To", comment: "Header text above conversion conversion destination symbol and conversion amount")
            
        case 2:
            return NSLocalizedString("All Currencies", comment: "Header text above all destination currencies")
            
        default:
            fatalError("TableView requeting title for section out of bounds \(section)")
        }
    }
}

