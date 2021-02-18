//
//  ExpenseCategoryLocalDataSource.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
protocol ExpenseCategoryLocalDataSource {
    func save(_ expenseCategory: ExpenseCategory)
    func fetchAll() -> [ExpenseCategory]
}

class ExpenseCategoryLocalDataSourceImpl: ExpenseCategoryLocalDataSource {
    private let coreDataPersistence: CoreDataPersistence;
    
    init(coreDataPersistence: CoreDataPersistence) {
        self.coreDataPersistence = coreDataPersistence;
    }
    
    func fetchAll() -> [ExpenseCategory] {
        let entities = self.coreDataPersistence.fetchAll(type: ExpenseCategoryCoreDataEntity.self);
        let expenseCategories = entities.map { (entity) -> ExpenseCategory in
            return convertToExpenseCategory(entity);
        }
        return expenseCategories;
    }
    
    private func convertToExpenseCategory(_ entity: ExpenseCategoryCoreDataEntity) -> ExpenseCategory {
        return ExpenseCategory.init(id: entity.objectID.uriRepresentation().absoluteString, type: entity.type!, amount: entity.amount);
    }
    
    func save(_ expenseCategory: ExpenseCategory) {
        var expenseCategoryEntity: ExpenseCategoryCoreDataEntity!
        if let id = expenseCategory.id {
            expenseCategoryEntity = self.coreDataPersistence.fetch(type: ExpenseCategoryCoreDataEntity.self, id: id);
        } else {
            expenseCategoryEntity = self.coreDataPersistence.create(type: ExpenseCategoryCoreDataEntity.self);
        }
        
        copyTransactionValues(expenseCategory, to: expenseCategoryEntity);
        self.coreDataPersistence.save();
    }
    
    private func copyTransactionValues(_ expenseCateory: ExpenseCategory, to entity: ExpenseCategoryCoreDataEntity) {
        entity.type = expenseCateory.type;
        entity.amount = expenseCateory.amount;
    }
}
