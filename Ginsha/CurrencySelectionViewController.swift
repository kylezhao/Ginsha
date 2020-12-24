//
//  CurrencySelectionViewController.swift
//  Ginsha
//
//  Created by Kyle Zhao on 12/21/20.
//

import UIKit
import GinCore

class CurrencySelectionViewController: UITableViewController {
    private let currencyCellID = "currencyCell"
    var selectionHandler: ((_ symbol: String, _ name: String) -> ())?
    
    var supportedCurrenciesResult: SupportedCurrenciesResult? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let result = self.supportedCurrenciesResult else { return }
        
        let prefix = result.sortedPrefixArray[indexPath.section]
        let symbols = result.prefixToSymbolsDictionary[prefix]
        let symbol = symbols![indexPath.row]
        let name = result.symbolToNameDictionary[symbol]!
        
        selectionHandler?(symbol, NSLocalizedString(name, comment: "Currency Name for \(symbol)"))
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return supportedCurrenciesResult?.sortedPrefixArray.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = self.supportedCurrenciesResult,
              let symbolsArray = result.prefixToSymbolsDictionary[result.sortedPrefixArray[section]] else { return 0 }
        
        return symbolsArray.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let result = self.supportedCurrenciesResult else { return nil }
        return result.sortedPrefixArray
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let result = self.supportedCurrenciesResult else { return nil }
        return result.sortedPrefixArray[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = self.supportedCurrenciesResult else {
            fatalError("Trying create cell without SupportedCurrenciesResult")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellID, for: indexPath)
        let prefix = result.sortedPrefixArray[indexPath.section]
        let symbols = result.prefixToSymbolsDictionary[prefix]
        let symbol = symbols![indexPath.row]
        let name = result.symbolToNameDictionary[symbol]!
        cell.textLabel?.text = NSLocalizedString(name, comment: "Currency Name for \(symbol)")
        cell.detailTextLabel?.text = symbol
        return cell
    }
}

/*
 
 let symbolToNameDictionary = [
 "HRK" : "Croatian Kuna",
 "HUF" : "Hungarian Forint",
 "CDF" : "Congolese Franc",
 "ILS" : "Israeli New Sheqel",
 "NGN" : "Nigerian Naira",
 "GYD" : "Guyanaese Dollar",
 "BYR" : "Belarusian Ruble",
 "BHD" : "Bahraini Dinar",
 "SZL" : "Swazi Lilangeni",
 "INR" : "Indian Rupee",
 "SDG" : "Sudanese Pound",
 "PEN" : "Peruvian Nuevo Sol",
 "EUR" : "Euro",
 "QAR" : "Qatari Rial",
 "PGK" : "Papua New Guinean Kina",
 "LRD" : "Liberian Dollar",
 "ISK" : "Icelandic Króna",
 "SYP" : "Syrian Pound",
 "TRY" : "Turkish Lira",
 "UAH" : "Ukrainian Hryvnia",
 "SGD" : "Singapore Dollar",
 "MMK" : "Myanma Kyat",
 "NIO" : "Nicaraguan Córdoba",
 "BIF" : "Burundian Franc",
 "AFN" : "Afghan Afghani",
 "LKR" : "Sri Lankan Rupee",
 "GTQ" : "Guatemalan Quetzal",
 "CHF" : "Swiss Franc",
 "THB" : "Thai Baht",
 "AMD" : "Armenian Dram",
 "AOA" : "Angolan Kwanza",
 "SEK" : "Swedish Krona",
 "SAR" : "Saudi Riyal",
 "KWD" : "Kuwaiti Dinar",
 "IRR" : "Iranian Rial",
 "WST" : "Samoan Tala",
 "BGN" : "Bulgarian Lev",
 "BMD" : "Bermudan Dollar",
 "PHP" : "Philippine Peso",
 "XAF" : "CFA Franc BEAC",
 "ZMW" : "Zambian Kwacha",
 "BDT" : "Bangladeshi Taka",
 "NOK" : "Norwegian Krone",
 "BOB" : "Bolivian Boliviano",
 "TZS" : "Tanzanian Shilling",
 "BND" : "Brunei Dollar",
 "VEF" : "Venezuelan Bolívar Fuerte",
 "ANG" : "Netherlands Antillean Guilder",
 "SCR" : "Seychellois Rupee",
 "VUV" : "Vanuatu Vatu",
 "XAG" : "Silver (troy ounce)",
 "XCD" : "East Caribbean Dollar",
 "KYD" : "Cayman Islands Dollar",
 "DJF" : "Djiboutian Franc",
 "CLF" : "Chilean Unit of Account (UF)",
 "LSL" : "Lesotho Loti",
 "MOP" : "Macanese Pataca",
 "ALL" : "Albanian Lek",
 "UZS" : "Uzbekistan Som",
 "PLN" : "Polish Zloty",
 "UYU" : "Uruguayan Peso",
 "LTL" : "Lithuanian Litas",
 "LYD" : "Libyan Dinar",
 "JPY" : "Japanese Yen",
 "MNT" : "Mongolian Tugrik",
 "FJD" : "Fijian Dollar",
 "ZWL" : "Zimbabwean Dollar",
 "KPW" : "North Korean Won",
 "PKR" : "Pakistani Rupee",
 "MRO" : "Mauritanian Ouguiya",
 "GBP" : "British Pound Sterling",
 "OMR" : "Omani Rial",
 "LVL" : "Latvian Lats",
 "SHP" : "Saint Helena Pound",
 "GEL" : "Georgian Lari",
 "TND" : "Tunisian Dinar",
 "DKK" : "Danish Krone",
 "KRW" : "South Korean Won",
 "NPR" : "Nepalese Rupee",
 "BSD" : "Bahamian Dollar",
 "CRC" : "Costa Rican Colón",
 "EGP" : "Egyptian Pound",
 "AUD" : "Australian Dollar",
 "BTC" : "Bitcoin",
 "MAD" : "Moroccan Dirham",
 "SLL" : "Sierra Leonean Leone",
 "MWK" : "Malawian Kwacha",
 "RSD" : "Serbian Dinar",
 "NZD" : "New Zealand Dollar",
 "SRD" : "Surinamese Dollar",
 "CLP" : "Chilean Peso",
 "RUB" : "Russian Ruble",
 "HKD" : "Hong Kong Dollar",
 "NAD" : "Namibian Dollar",
 "GMD" : "Gambian Dalasi",
 "VND" : "Vietnamese Dong",
 "LAK" : "Laotian Kip",
 "CUC" : "Cuban Convertible Peso",
 "RON" : "Romanian Leu",
 "MUR" : "Mauritian Rupee",
 "XAU" : "Gold (troy ounce)",
 "GGP" : "Guernsey Pound",
 "BRL" : "Brazilian Real",
 "MXN" : "Mexican Peso",
 "STD" : "São Tomé and Príncipe Dobra",
 "AWG" : "Aruban Florin",
 "MVR" : "Maldivian Rufiyaa",
 "PAB" : "Panamanian Balboa",
 "TJS" : "Tajikistani Somoni",
 "GNF" : "Guinean Franc",
 "MGA" : "Malagasy Ariary",
 "XDR" : "Special Drawing Rights",
 "ETB" : "Ethiopian Birr",
 "COP" : "Colombian Peso",
 "ZAR" : "South African Rand",
 "IDR" : "Indonesian Rupiah",
 "SVC" : "Salvadoran Colón",
 "CVE" : "Cape Verdean Escudo",
 "TTD" : "Trinidad and Tobago Dollar",
 "GIP" : "Gibraltar Pound",
 "PYG" : "Paraguayan Guarani",
 "MZN" : "Mozambican Metical",
 "FKP" : "Falkland Islands Pound",
 "KZT" : "Kazakhstani Tenge",
 "UGX" : "Ugandan Shilling",
 "USD" : "United States Dollar",
 "ARS" : "Argentine Peso",
 "GHS" : "Ghanaian Cedi",
 "RWF" : "Rwandan Franc",
 "DOP" : "Dominican Peso",
 "JEP" : "Jersey Pound",
 "LBP" : "Lebanese Pound",
 "BTN" : "Bhutanese Ngultrum",
 "BZD" : "Belize Dollar",
 "MYR" : "Malaysian Ringgit",
 "YER" : "Yemeni Rial",
 "JMD" : "Jamaican Dollar",
 "TOP" : "Tongan Paʻanga",
 "SOS" : "Somali Shilling",
 "TMT" : "Turkmenistani Manat",
 "MDL" : "Moldovan Leu",
 "XOF" : "CFA Franc BCEAO",
 "TWD" : "New Taiwan Dollar",
 "BBD" : "Barbadian Dollar",
 "CAD" : "Canadian Dollar",
 "CNY" : "Chinese Yuan",
 "JOD" : "Jordanian Dinar",
 "XPF" : "CFP Franc",
 "IQD" : "Iraqi Dinar",
 "HNL" : "Honduran Lempira",
 "AED" : "United Arab Emirates Dirham",
 "ERN" : "Eritrean Nakfa",
 "KES" : "Kenyan Shilling",
 "KMF" : "Comorian Franc",
 "DZD" : "Algerian Dinar",
 "MKD" : "Macedonian Denar",
 "CUP" : "Cuban Peso",
 "BWP" : "Botswanan Pula",
 "AZN" : "Azerbaijani Manat",
 "SBD" : "Solomon Islands Dollar",
 "BYN" : "New Belarusian Ruble",
 "KGS" : "Kyrgystani Som",
 "KHR" : "Cambodian Riel",
 "ZMK" : "Zambian Kwacha (pre-2013)",
 "HTG" : "Haitian Gourde",
 "CZK" : "Czech Republic Koruna",
 "BAM" : "Bosnia-Herzegovina Convertible Mark",
 "IMP" : "Manx pound"
 ]
 */
