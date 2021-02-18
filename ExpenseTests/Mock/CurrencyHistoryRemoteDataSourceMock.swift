//
//  CurrencyHistoryRemoteDataSourceMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
@testable import Expense

class CurrencyHistoryRemoteDataSourceMock: CurrencyHistoryRemoteDataSource {
    var getFunctionExecutionCount: Int = 0
    var getFunctionParameterDate: Date?
    var getFunctionCompletionResult: Result<CurrencyHistoryEntity> = .failure(NSError.init());

    func get(date: Date, completion: @escaping (Result<CurrencyHistoryEntity>) -> Void) {
        getFunctionExecutionCount += 1;
        getFunctionParameterDate = date;
        completion(getFunctionCompletionResult);
    }
}
