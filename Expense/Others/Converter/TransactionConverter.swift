//
//  TransactionAmountToString.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import CoreData

func convertTransactionToAmountString(_ transaction: Transaction) -> String {
    var amount = 0.0;
    switch transaction.currency {
    case .nzd:
        amount = transaction.amountInNZD;
    case .usd:
        amount = transaction.amountInUSD;
    }
    return String(format: Constant.MoneyFormat.General, amount);
}

func convertCurrencyToString(_ currencyType: CurrencyType) -> String
{
    switch currencyType {
    case .nzd:
        return "NZD";
    case .usd:
        return "USD";
    }
}
