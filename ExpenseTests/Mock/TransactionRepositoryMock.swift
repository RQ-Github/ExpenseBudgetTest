//
//  TransactionRepositoryMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 19/02/21.
//
@testable import Expense

class TransactionRepositoryMock: TransactionRepository {
    private (set) var fetchAllExecutionCount = 0;
    var getTransactionResponse = [Transaction]()
    
    private (set) var saveExecutionCount = 0;
    private (set) var savedTransaction: Transaction?
    
    func fetchAll() -> [Transaction] {
        fetchAllExecutionCount += 1;
        return getTransactionResponse;
    }
    
    func save(transaction: Transaction) {
        self.savedTransaction = transaction;
        saveExecutionCount += 1;
    }
}
