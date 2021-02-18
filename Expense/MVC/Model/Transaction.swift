//
//  Transaction.swift
//  Expense
//
//  Created by Ray Qu on 17/02/21.
//

import Foundation
enum CurrencyType : CaseIterable {
    case nzd
    case usd
}

struct Transaction : Equatable {
    var id: String?
    var amountInNZD: Double;
    var amountInUSD: Double;
    var date: Date;
    var currency: CurrencyType;
    var category: ExpenseCategory;
}
