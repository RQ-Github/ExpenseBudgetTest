//
//  ExpenseCategorySetup.swift
//  Expense
//
//  Created by Ray Qu on 19/02/21.
//

import Foundation
protocol ExpenseCategorySetup {
    func initialSetup()
}
class ExpenseCategorySetupImpl : ExpenseCategorySetup {
    private var getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase;
    private var saveExpenseCategoryUseCase: SaveExpenseCategoryUseCase;

    init(getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase, saveExpenseCategoryUseCase: SaveExpenseCategoryUseCase) {
        self.getExpenseCategoriesUseCase = getExpenseCategoriesUseCase;
        self.saveExpenseCategoryUseCase = saveExpenseCategoryUseCase;
    }
    
    func initialSetup() {
        let categories = self.getExpenseCategoriesUseCase.execute();
        if categories.count != 0 {
            return;
        }
        
        let category1 = ExpenseCategory.init(type: "Gas");
        let category2 = ExpenseCategory.init(type: "Rent");
        let category3 = ExpenseCategory.init(type: "Grocery");
        self.saveExpenseCategoryUseCase.execute(category1);
        self.saveExpenseCategoryUseCase.execute(category2);
        self.saveExpenseCategoryUseCase.execute(category3);
    }
}
