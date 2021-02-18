//
//  TransactionRepositoryTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//

import XCTest
@testable import Expense

class TransactionRepositoryTests: XCTestCase {
    var repository: TransactionRepositoryImpl!;
    var localDataSource: TransactionLocalDataSourceMock!;
    
    override func setUpWithError() throws {
        localDataSource = TransactionLocalDataSourceMock.init();
        repository = TransactionRepositoryImpl.init(localDataSource: localDataSource!);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchAllCallsLocalDataSourceFetchAll() throws {
        // ACT
        _ = repository.fetchAll();
        
        // ASSERT
        XCTAssertEqual(localDataSource.fetchAllExecutionCount, 1);
    }
    
    func testFetchAllShouldReturnDataFromLocalDataSource() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        
        let data = [transaction];
        localDataSource.fetchAllResponse = data;
        
        // ACT
        let response = repository.fetchAll();
        
        // ASSERT
        XCTAssertEqual(response, data);
    }
    
    func testSaveShouldCallLocalDataSourceSave() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        
        // ACT
        repository.save(transaction: transaction);
        
        // ASSERT
        let savedExpenseCategory = localDataSource.savedTransaction!
        XCTAssertEqual(localDataSource.saveExecutionCount, 1);
        XCTAssertEqual(savedExpenseCategory, transaction);
    }
}
