//
//  ExpenseCategoryRepository.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import Foundation
import UIKit
import CoreData

protocol ExpenseCategoryRepository {
    func fetchAll() -> [ExpenseCategory]
    func save(_ expenseCategory: ExpenseCategory)
}

class ExpenseCategoryRepositoryImpl : ExpenseCategoryRepository{
    private let localDataSource : ExpenseCategoryLocalDataSource;
    init(_ localDataSource : ExpenseCategoryLocalDataSource) {
        self.localDataSource = localDataSource;
    }
    
    func save(_ expenseCategory: ExpenseCategory) {
        self.localDataSource.save(expenseCategory);
    }
    
    func fetchAll() -> [ExpenseCategory] {
        return self.localDataSource.fetchAll();
    }
}

