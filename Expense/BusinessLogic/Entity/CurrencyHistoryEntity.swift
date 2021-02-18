//
//  HistoryCurrencyEntity.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
struct Quote {
    let currencyRatioName: String
    let ratio: Double
    
    static func fromDictionary(dict: [String: Double]) -> [Self] {
        var array = [Self]()
        dict.forEach { (key, value) in
            let quote = Quote.init(currencyRatioName: key, ratio: value);
            array.append(quote);
        }
        
        return array;
    }
}

struct CurrencyHistoryEntity {
    let historical: Bool
    let date: Date
    let source: String
    let quotes: [Quote]
    
    static func fromDictionary(dict: [String:Any]) -> Self? {
        guard let historical = dict["historical"] as? Bool,
              let dateString = dict["date"] as? String,
              let date = Date.fromUTCString(dateString, format: "yyyy-MM-dd"),
              let source = dict["source"] as? String,
              let quotes = dict["quotes"] as? [String: Double]
        else {
            return nil;
        }
        
        return CurrencyHistoryEntity.init(historical: historical, date: date, source: source, quotes: Quote.fromDictionary(dict: quotes))
    }
}
