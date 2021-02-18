//
//  ExpenseCategoryRepositoryTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 14/02/21.
//

import XCTest
@testable import Expense

class ExpenseCategoryRepositoryTests: XCTestCase {
    
    private var localDataSource : ExpenseCategoryLocalDataSourceMock!
    private var repository : ExpenseCategoryRepository!
    
    override func setUpWithError() throws {
        localDataSource = ExpenseCategoryLocalDataSourceMock.init();
        repository = ExpenseCategoryRepositoryImpl.init(localDataSource);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchAllShouldCallLocalDataSourceFetchAll() throws {
        // ACT
        _ = repository.fetchAll();
        
        // ASSERT
        XCTAssertEqual(localDataSource.fetchAllExecutionCount, 1);
    }
    
    func testFetchAllShouldReturnDataFromLocalDataSource() throws {
        // ARRANGE
        let expenseCategory = ExpenseCategory.init(id: "id", type: "type", amount: 100.0);
        let data = [expenseCategory];
        localDataSource.fetchAllResponse = data;
        
        // ACT
        let response = repository.fetchAll();
        
        // ASSERT
        XCTAssertEqual(response, data);
    }
    
    func testSaveShouldCallLocalDataSourceSave() throws {
        // ARRANGE
        let expenseCategory = ExpenseCategory.init(type: "Gas", amount: 200)
        
        // ACT
        repository.save(expenseCategory);
        
        // ASSERT
        let savedExpenseCategory = localDataSource.savedExpenseCategory!
        XCTAssertEqual(localDataSource.saveExecutionCount, 1);
        XCTAssertEqual(savedExpenseCategory, expenseCategory);
    }
}
