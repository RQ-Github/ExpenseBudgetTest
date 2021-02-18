//
//  ExpenseCategoryLocalDataSourceMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//

import Foundation
@testable import Expense

class ExpenseCategoryLocalDataSourceMock : ExpenseCategoryLocalDataSource{
    private (set) var fetchAllExecutionCount = 0;
    private (set) var saveExecutionCount = 0;
    var savedExpenseCategory: ExpenseCategory?
    var fetchAllResponse = [ExpenseCategory]()
    
    func save(_ expenseCategory: ExpenseCategory) {
        saveExecutionCount += 1;
        savedExpenseCategory = expenseCategory;
    }
    
    func fetchAll() -> [ExpenseCategory] {
        fetchAllExecutionCount += 1;
        return fetchAllResponse;
    }
}
