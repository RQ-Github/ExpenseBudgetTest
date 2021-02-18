//
//  ExpenseCategoryConverter.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation

func convertToExpenseCategory(from entity: ExpenseCategoryCoreDataEntity) -> ExpenseCategory {
    ExpenseCategory.init(id: entity.objectID.uriRepresentation().absoluteString, type: entity.type!, amount: entity.amount);
}
