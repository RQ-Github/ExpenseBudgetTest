//
//  CurrencyRepositoryTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 18/02/21.
//

import XCTest
@testable import Expense

class CurrencyRepositoryTests: XCTestCase {
    
    private var currencyHistoryRemoteDataSourceMock : CurrencyHistoryRemoteDataSourceMock!
    private var repostory : CurrencyRepository!
    
    override func setUpWithError() throws {
        currencyHistoryRemoteDataSourceMock = CurrencyHistoryRemoteDataSourceMock.init();
        repostory = CurrencyRepositoryImpl.init(currencyHistoryDataSource: currencyHistoryRemoteDataSourceMock)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetUSDtoNZDCurrencyCallsCurrencyHistoryRemoteDataSourceWithCorrectParameter() {
        // ARRANGE
        let date = Date.init();
        
        // ACT
        repostory.getUSDToNZDCurrency(date: date) { (result) in
        }
        
        // ASSERT
        XCTAssertEqual(currencyHistoryRemoteDataSourceMock.getFunctionParameterDate, date);
        XCTAssertEqual(currencyHistoryRemoteDataSourceMock.getFunctionExecutionCount, 1);
    }
    
    func testGetUSDtoNZDCurrencyReturnsErrorIfRemoteDataReturnsError() {
        // ARRANGE
        let date = Date.init();
        currencyHistoryRemoteDataSourceMock.getFunctionCompletionResult = .failure(NSError.init())
        var failureCompletionCount = 0
        
        // ACT & ASSERT
        repostory.getUSDToNZDCurrency(date: date) { (result) in
            switch result {
            case .success(_):
                break;
            case .failure(_):
                failureCompletionCount += 1;
            }
        }
        
        // ASSERT
        XCTAssertEqual(failureCompletionCount, 1);
    }
    
    func testGetUSDtoNZDCurrencyReturnsErrorIfEntityDoesNotContainCorrectData() {
        // ARRANGE
        let date = Date.init();
        let quote = Quote.init(currencyRatioName: "AUDNZD", ratio: 1.35);
        let entity = CurrencyHistoryEntity.init(historical: true, date: Date.init(), source: "", quotes: [quote])
        currencyHistoryRemoteDataSourceMock.getFunctionCompletionResult = .success(entity)
        var failureCompletionCount = 0
        
        // ACT & ASSERT
        repostory.getUSDToNZDCurrency(date: date) { (result) in
            switch result {
            case .success(_):
                break;
            case .failure(_):
                failureCompletionCount += 1;
            }
        }
        
        // ASSERT
        XCTAssertEqual(failureCompletionCount, 1);
    }
    
    func testGetUSDtoNZDCurrencyReturnsExpectedResult() {
        // ARRANGE
        let date = Date.init();
        let quote = Quote.init(currencyRatioName: "USDNZD", ratio: 1.35);
        let entity = CurrencyHistoryEntity.init(historical: true, date: date, source: "", quotes: [quote])
        
        currencyHistoryRemoteDataSourceMock.getFunctionCompletionResult = .success(entity)
        var currencyResult: USDToNZDCurrency?
        
        // ACT & ASSERT
        repostory.getUSDToNZDCurrency(date: date) { (result) in
            switch result {
            case .success(let currency):
                currencyResult = currency
                break;
            case .failure(_):
                break;
            }
        }
        
        // ASSERT
        XCTAssertEqual(currencyResult?.date, entity.date);
        XCTAssertEqual(currencyResult?.ratio, quote.ratio);
    }
}
