//
//  SaveExpenseCategoryUseCase.swift
//  Expense
//
//  Created by Ray Qu on 16/02/21.
//

import Foundation

protocol SaveExpenseCategoryUseCase {
    func execute(_ expenseCategory: ExpenseCategory)
}

class SaveExpenseCategoryUseCaseImpl: SaveExpenseCategoryUseCase {
    private let repository : ExpenseCategoryRepository;
    
    init(_ expenseCategoryRepository : ExpenseCategoryRepository) {
        self.repository = expenseCategoryRepository;
    }
    
    func execute(_ expenseCategory: ExpenseCategory) {
        self.repository.save(expenseCategory);
    }
}
