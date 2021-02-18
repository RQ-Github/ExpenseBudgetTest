//
//  SaveTransactionUseCaseTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//

import XCTest
@testable import Expense

class SaveTransactionUseCaseTests: XCTestCase {
    
    private var useCase : SaveTransactionUseCase!
    private var transactionRepositoryMock : TransactionRepositoryMock!
    private var currencyRepository : CurrencyRepositoryMock!
    
    override func setUpWithError() throws {
        transactionRepositoryMock = TransactionRepositoryMock();
        currencyRepository = CurrencyRepositoryMock();
        useCase = SaveTransactionUseCaseImp(transactionRepository: transactionRepositoryMock, currencyRepository: currencyRepository);
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUseCaseExecuteShouldCallCurrencyRepositoryToGetCurrency() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        
        // ACT
        self.useCase.execute(transaction: transaction) { (result) in
            
        }
        
        // ASSERT
        XCTAssertEqual(currencyRepository.getUSDToNZDCurrencyExecutionCount, 1);
        XCTAssertEqual(transactionRepositoryMock.saveExecutionCount, 0);
    }
    
    func testUseCaseExecuteShouldReturnIfCurrencyRepositoryFails() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        self.currencyRepository.getUSDToNZDCurrencyError = true;
        var failureCount = 0;
        
        // ACT
        self.useCase.execute(transaction: transaction) { (result) in
            switch result{
            case .success():
                break;
            case .failure(_):
                failureCount += 1;
            }
        }
        
        // ASSERT
        XCTAssertEqual(failureCount, 1);
    }
    
    func testUseCaseExecuteShouldSaveTransactionWithCurrencyAppliedIfSelectedCurrencyIsNZD() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .nzd, category: category);
        self.currencyRepository.usdToNZDCurrency = USDToNZDCurrency.init(date: Date.init(), ratio: 2);
        var expectedTransaction = transaction;
        expectedTransaction.amountInUSD = 50;
        
        // ACT
        self.useCase.execute(transaction: transaction) { (result) in
        }
        
        // ASSERT
        XCTAssertEqual(self.transactionRepositoryMock.savedTransaction, expectedTransaction);
        XCTAssertEqual(self.transactionRepositoryMock.saveExecutionCount, 1);
    }
    
    func testUseCaseExecuteShouldSaveTransactionWithCurrencyAppliedIfSelectedCurrencyIsUSD() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .usd, category: category);
        self.currencyRepository.usdToNZDCurrency = USDToNZDCurrency.init(date: Date.init(), ratio: 2);
        var expectedTransaction = transaction;
        expectedTransaction.amountInNZD = 240;
        
        // ACT
        self.useCase.execute(transaction: transaction) { (result) in
        }
        
        // ASSERT
        XCTAssertEqual(self.transactionRepositoryMock.savedTransaction, expectedTransaction);
        XCTAssertEqual(self.transactionRepositoryMock.saveExecutionCount, 1);
    }
    
    
    func testUseCaseExecuteReturnSuccessWhenRepositorySaveFinishes() throws {
        // ARRANGE
        let category = ExpenseCategory.init(id: "id1", type: "type", amount: 10);
        let transaction = Transaction.init(id: "id", amountInNZD: 100.0, amountInUSD: 120.0, date: Date.init(), currency: .usd, category: category);
        self.currencyRepository.usdToNZDCurrency = USDToNZDCurrency.init(date: Date.init(), ratio: 2);
        var successCount = 0;
        
        // ACT
        self.useCase.execute(transaction: transaction) { (result) in
            switch result {
            case .success():
                successCount += 1;
            case .failure(_):
                XCTFail();
            }
        }
        
        // ASSERT
        XCTAssertEqual(self.transactionRepositoryMock.saveExecutionCount, 1);
        XCTAssertEqual(successCount, 1);
    }
}
