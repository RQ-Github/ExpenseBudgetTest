//
//  TransactionRepository.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation

protocol TransactionRepository {
    func fetchAll() -> [Transaction]
    func save(transaction: Transaction)
}

class TransactionRepositoryImpl : TransactionRepository {
    private let localDataSource: TransactionLocalDataSource;
    
    init(localDataSource: TransactionLocalDataSource) {
        self.localDataSource = localDataSource;
    }
    
    func fetchAll() -> [Transaction] {
        return self.localDataSource.fetchAllTransactions();
    }
    
    func save(transaction: Transaction) {
        localDataSource.save(transaction: transaction);
    }
}
