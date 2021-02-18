//
//  ExpenseCategory.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import Foundation
enum ExpenseCategoryColor {
    case red
    case green
    case pink
}

struct ExpenseCategory: Equatable {
    var id: String?;
    var type : String;
    var amount : Double = 500;
}
