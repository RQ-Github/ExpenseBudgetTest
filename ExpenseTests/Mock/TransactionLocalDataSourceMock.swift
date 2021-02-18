//
//  TransactionLocalDataSourceMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//

import Foundation
import Foundation
@testable import Expense

class TransactionLocalDataSourceMock : TransactionLocalDataSource{
    private (set) var fetchAllExecutionCount = 0;
    private (set) var saveExecutionCount = 0;
    var savedTransaction: Transaction?
    var fetchAllResponse = [Transaction]()
    
    func save(transaction: Transaction) {
        saveExecutionCount += 1;
        savedTransaction = transaction;
    }
    
    func fetchAllTransactions() -> [Transaction] {
        fetchAllExecutionCount += 1;
        return fetchAllResponse;
    }
}
