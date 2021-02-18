//
//  ExpenseCategoryRepositoryMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 14/02/21.
//

@testable import Expense

class ExpenseCategoryRepositoryMock: ExpenseCategoryRepository {
    private (set) var getExpenseCategoriesExecutionCount = 0;
    var getExpenseCategoriesReturns = [ExpenseCategory]()
    
    private (set) var saveExpenseCategoryExecutionCount = 0;
    private (set) var savedExpenseCategory: ExpenseCategory?
    
    func fetchAll() -> [ExpenseCategory] {
        getExpenseCategoriesExecutionCount += 1;
        return getExpenseCategoriesReturns;
    }
    
    func save(_ expenseCategory: ExpenseCategory) {
        self.savedExpenseCategory = expenseCategory;
        saveExpenseCategoryExecutionCount += 1;
    }
}
