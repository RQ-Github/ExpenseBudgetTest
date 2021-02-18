//
//  GetTransactionsUseCase.swift
//  Expense
//
//  Created by Ray Qu on 19/02/21.
//

import Foundation
protocol GetTransactionsUseCase {
    func execute() -> [TransactionSection];
}

class GetTransactionsUseCaseImpl: GetTransactionsUseCase {
    let transactionRepository: TransactionRepository
    
    init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository;
    }
    
    func execute() -> [TransactionSection] {
        let transactions = self.transactionRepository.fetchAll();
        
        var sections = groupTransactions(transactions: transactions);
        sections.sort { (t1, t2) -> Bool in
            return t1.date.compare(t2.date) == .orderedDescending;
        }
        
        return sections;
    }
    
    private func groupTransactions(transactions: [Transaction]) -> [TransactionSection]{
        let cal = Calendar.current
        let dict = Dictionary.init(grouping: transactions) { (element) -> Date in
            return cal.startOfDay(for: element.date);
        }
        
        var transactionSections = [TransactionSection]();
        dict.forEach { (key, value) in
            let sortedTransactions = sortTransactionByDate(transactions: value);
            let transactionSection = TransactionSection.init(date: key, transactions: sortedTransactions);
            transactionSections.append(transactionSection)
        }
        
        return transactionSections;
    }
    
    private func sortTransactionByDate(transactions: [Transaction]) -> [Transaction] {
        var transactions = transactions;
        transactions.sort { (t1, t2) -> Bool in
            return t1.date.compare(t2.date) == .orderedDescending;
        }
        
        return transactions;
    }
}
