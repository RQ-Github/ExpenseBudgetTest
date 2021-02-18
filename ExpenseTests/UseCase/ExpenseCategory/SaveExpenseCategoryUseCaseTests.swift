//
//  SaveExpenseCategoryUseCaseTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 16/02/21.
//

import XCTest
@testable import Expense

class SaveExpenseCategoryUseCaseTests: XCTestCase {
    
    private var useCase : SaveExpenseCategoryUseCase!
    private var repositoryMock : ExpenseCategoryRepositoryMock!
    
    override func setUpWithError() throws {
        repositoryMock = ExpenseCategoryRepositoryMock();
        useCase = SaveExpenseCategoryUseCaseImpl(repositoryMock);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUseCaseExecuteShouldCallRepositorySaveExpenseCategory() throws {
       // ARRANGE
        let expenseCategory = ExpenseCategory.init(type: "Gas", amount: 200);
        
        // ACT
        self.useCase.execute(expenseCategory)
        
        // ASSERT
        XCTAssertEqual(repositoryMock.saveExpenseCategoryExecutionCount, 1);
        XCTAssertEqual(repositoryMock.savedExpenseCategory, expenseCategory);
    }
}
