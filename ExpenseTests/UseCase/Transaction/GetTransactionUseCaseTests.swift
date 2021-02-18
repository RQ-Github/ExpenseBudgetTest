//
//  GetTransactionUseCaseTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//

import XCTest
@testable import Expense

class GetTransactionUseCaseTests: XCTestCase {
    private var useCase : GetTransactionsUseCase!
    private var repositoryMock : TransactionRepositoryMock!
    
    override func setUpWithError() throws {
        repositoryMock = TransactionRepositoryMock();
        useCase = GetTransactionsUseCaseImpl(transactionRepository: repositoryMock);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUseCaseExecuteShouldCallRepositoryFetchAll() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        repositoryMock.getTransactionResponse = [transaction]
        
        // ACT
        let response = useCase.execute();
        
        // ASSERT
        XCTAssertEqual(repositoryMock.fetchAllExecutionCount, 1);
        XCTAssertEqual(response.count, 1);
    }
}
