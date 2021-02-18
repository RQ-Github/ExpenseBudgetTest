//
//  CurrencyRepositoryMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//
import Foundation
@testable import Expense

class CurrencyRepositoryMock: CurrencyRepository {
    
    
    private (set) var getUSDToNZDCurrencyExecutionCount = 0;
    var getUSDToNZDCurrencyError = false;
    var usdToNZDCurrency: USDToNZDCurrency?;

    func getUSDToNZDCurrency(date: Date, _ completionHandler: @escaping (Result<USDToNZDCurrency>) -> Void) {
        getUSDToNZDCurrencyExecutionCount += 1;
        if getUSDToNZDCurrencyError {
            completionHandler(Result.failure(NSError.init()));
            return;
        }
        if let currency = self.usdToNZDCurrency {
            completionHandler(Result.success(currency));
        }
    }
}
