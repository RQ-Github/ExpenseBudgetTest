//
//  SaveTransactionUseCase.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation

protocol SaveTransactionUseCase {
    func execute(transaction: Transaction, completion:@escaping (Result<Void>) -> Void)
}


class SaveTransactionUseCaseImp : SaveTransactionUseCase {
    let transactionRepository: TransactionRepository
    let currencyRepository: CurrencyRepository
    
    init(transactionRepository: TransactionRepository, currencyRepository: CurrencyRepository) {
        self.transactionRepository = transactionRepository;
        self.currencyRepository = currencyRepository;
    }
    
    func execute(transaction: Transaction, completion:@escaping (Result<Void>) -> Void) {
        self.currencyRepository.getUSDToNZDCurrency(date: transaction.date) {[weak self] (result) in
            self?.onGetCurrencyCompletion(transaction: transaction, result: result, completion: completion)
        }
    }
    
    private func onGetCurrencyCompletion(transaction: Transaction, result: Result<USDToNZDCurrency>, completion:@escaping (Result<Void>) -> Void) {
        switch result {
        case .success(let currency):
            let transaction = setTransactionCurrency(transaction: transaction, currency: currency);
            self.transactionRepository.save(transaction: transaction);
            completion(Result.success(()));
        case .failure(let error):
            completion(Result.failure(error))
        }
    }
    
    private func setTransactionCurrency(transaction: Transaction, currency: USDToNZDCurrency) -> Transaction {
        var transaction = transaction;
        switch transaction.currency {
        case .nzd:
            transaction.amountInUSD = transaction.amountInNZD / currency.ratio;
        case .usd:
            transaction.amountInNZD = transaction.amountInUSD * currency.ratio;
        }
        
        return transaction;
    }
    
    private func saveTransaction(transaction: Transaction) {
        transactionRepository.save(transaction: transaction);
    }
}
