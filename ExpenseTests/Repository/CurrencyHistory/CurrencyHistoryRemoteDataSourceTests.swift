//
//  CurrencyHistoryRemoteDataSourceTests.swift
//  ExpenseTests
//
//  Created by Ray Qu on 18/02/21.
//

import XCTest
@testable import Expense

class CurrencyHistoryRemoteDataSourceTests: XCTestCase {
    private var httpApiMock : HttpApiMock!
    private var dataSource : CurrencyHistoryRemoteDataSourceImpl!
    
    override func setUpWithError() throws {
        httpApiMock = HttpApiMock.init();
        dataSource = CurrencyHistoryRemoteDataSourceImpl.init(httpApiMock)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetShouldCallHttpApiWithCorrectParameters() throws {
        // ARRANGE
        let date = Date.init();
        let expectedDateString = date.toUTCString(format: CurrencyHistoryRemoteDataSourceImpl.dateFormat)

        // ACT
        dataSource.get(date: date) { (result) in
            
        }
        
        // ASSERT
        XCTAssertEqual(httpApiMock.getFunctionUrl, Constant.Url.CurrencyHistory)
        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyAccessKey], CurrencyHistoryRemoteDataSourceImpl.parameterValueAccessKey)
        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyCurrencies], CurrencyHistoryRemoteDataSourceImpl.parameterValueCurrencies)
        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyDate], expectedDateString)
        XCTAssertEqual(httpApiMock.getFunctionExecutionCount, 1)
    }
    
//    func testGetShouldCallHttpApiWithCorrectParameters() throws {
//        // ARRANGE
//        let date = Date.init();
//        let expectedDateString = date.toUTCString(format: CurrencyHistoryRemoteDataSourceImpl.dateFormat)
//
//        // ACT
//        dataSource.get(date: date) { (result) in
//            
//        }
//        
//        // ASSERT
//        XCTAssertEqual(httpApiMock.getFunctionUrl, Constant.Url.CurrencyHistory)
//        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyAccessKey], CurrencyHistoryRemoteDataSourceImpl.parameterValueAccessKey)
//        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyCurrencies], CurrencyHistoryRemoteDataSourceImpl.parameterValueCurrencies)
//        XCTAssertEqual(httpApiMock.getFunctionParameters![CurrencyHistoryRemoteDataSourceImpl.parameterKeyDate], expectedDateString)
//        XCTAssertEqual(httpApiMock.getFunctionExecutionCount, 1)
//    }
}
