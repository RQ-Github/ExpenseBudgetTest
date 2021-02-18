//
//  GetExpenseCategoryUseCaseTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 14/02/21.
//

import XCTest
@testable import Expense

class GetExpenseCategoryUseCaseTests: XCTestCase {
    private var useCase : GetExpenseCategoriesUseCase!
    private var repositoryMock : ExpenseCategoryRepositoryMock!
    
    override func setUpWithError() throws {
        repositoryMock = ExpenseCategoryRepositoryMock();
        useCase = GetExpenseCategoriesUseCaseImpl(repositoryMock);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUseCaseExecuteShouldCallRepositoryGetExpenseCategories() throws {
        // ARRANGE
        let expenseCategory = ExpenseCategory.init(type: "Rent", amount: 100);
        repositoryMock.getExpenseCategoriesReturns = [expenseCategory];
        
        // ACT
        let response = useCase.execute();
        
        // ASSERT
        XCTAssertEqual(repositoryMock.getExpenseCategoriesExecutionCount, 1);
        XCTAssertEqual(response.count, 1);
        XCTAssertEqual(response.first, expenseCategory);
    }
}
