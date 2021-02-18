//
//  GetExpenseCategoriesUseCase.swift
//  Expense
//
//  Created by Ray Qu on 13/02/21.
//

import Foundation

protocol GetExpenseCategoriesUseCase {
    func execute() -> [ExpenseCategory]
}

class GetExpenseCategoriesUseCaseImpl: GetExpenseCategoriesUseCase {
    private let repository : ExpenseCategoryRepository;
    
    init(_ expenseCategoryRepository : ExpenseCategoryRepository) {
        self.repository = expenseCategoryRepository;
    }
    
    func execute() -> [ExpenseCategory] {
        let response = self.repository.fetchAll();
        return response;
    }
}
