//
//  TransactionLocalDataSource.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import CoreData
protocol TransactionLocalDataSource {
    func save(transaction: Transaction)
    func fetchAllTransactions() -> [Transaction]
}

class TransactionLocalDataSourceImpl : TransactionLocalDataSource{
    private static let entityName = String(describing: TransactionEntity.self)
    private static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
    
    private static let currencyNZD = "NZD"
    private static let currencyUSD = "USD"

    
    private let coreDataPersistence: CoreDataPersistence;
    
    init(coreDataPersistence: CoreDataPersistence) {
        self.coreDataPersistence = coreDataPersistence;
    }
    
    func save(transaction: Transaction) {
        var transactionEntity: TransactionEntity!
        if let id = transaction.id {
            transactionEntity = self.coreDataPersistence.fetch(type: TransactionEntity.self, id: id);
        } else {
            transactionEntity = self.coreDataPersistence.create(type: TransactionEntity.self);
        }
       
        copyTransactionValues(transaction, to: transactionEntity);
        self.coreDataPersistence.save();
    }
    
    private func copyTransactionValues(_ transaction: Transaction, to transactionEntity: TransactionEntity) {
        transactionEntity.amountinUSD = transaction.amountInUSD;
        transactionEntity.amountInNZD = transaction.amountInNZD;
        transactionEntity.date = transaction.date.toUTCString(format: TransactionLocalDataSourceImpl.dateFormat);
        transactionEntity.expenseCategory = self.coreDataPersistence.fetch(type: ExpenseCategoryCoreDataEntity.self, id: transaction.category.id!)
        switch transaction.currency {
        case .nzd:
            transactionEntity.currency = TransactionLocalDataSourceImpl.currencyNZD;
        case .usd:
            transactionEntity.currency = TransactionLocalDataSourceImpl.currencyUSD;
        }
    }
    
    func fetchAllTransactions() -> [Transaction] {
        let entities = self.coreDataPersistence.fetchAll(type: TransactionEntity.self);
        let transactions = entities.map { (entity) -> Transaction in
            return convertToTransactionModel(transactionEntity: entity);
        }
        return transactions;
    }
    
    private func convertToTransactionModel(transactionEntity: TransactionEntity) -> Transaction {
        let date = Date.fromString(transactionEntity.date!, format: TransactionLocalDataSourceImpl.dateFormat)!;
        let currencyType = convertToCurrencyType(from: transactionEntity.currency!);
        let category = convertToExpenseCategory(from: transactionEntity.expenseCategory!);
        let transaction = Transaction.init(
            id: transactionEntity.objectID.uriRepresentation().absoluteString,
            amountInNZD: transactionEntity.amountInNZD,
            amountInUSD: transactionEntity.amountinUSD,
            date: date,
            currency: currencyType,
            category: category);
        
        return transaction;
    }
    
    private func convertToCurrencyType(from string: String) -> CurrencyType {
        switch string {
        case TransactionLocalDataSourceImpl.currencyUSD:
            return CurrencyType.usd;
        case TransactionLocalDataSourceImpl.currencyNZD:
            return CurrencyType.nzd;
        default:
            return CurrencyType.usd;
        }
    }
}
