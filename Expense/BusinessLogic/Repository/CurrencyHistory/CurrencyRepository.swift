//
//  CurrencyRepository.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation

enum CurrencyRepositoryError: Error {
    case cannotFindCurrency
}

protocol CurrencyRepository {
    func getUSDToNZDCurrency(date: Date, _ completionHandler: @escaping (Result<USDToNZDCurrency>) -> Void)
}

class CurrencyRepositoryImpl: CurrencyRepository {
    private static let USDToNZDCurrencyName = "USDNZD";
    
    let currencyHistoryDataSource: CurrencyHistoryRemoteDataSource
    init(currencyHistoryDataSource: CurrencyHistoryRemoteDataSource) {
        self.currencyHistoryDataSource = currencyHistoryDataSource;
    }
    
    func getUSDToNZDCurrency(date: Date, _ completionHandler: @escaping (Result<USDToNZDCurrency>) -> Void) {
        currencyHistoryDataSource.get(date: date) { [weak self] (result) in
            self?.onGetUSDToNZDCurrencyCompleted(result: result, completionHandler: completionHandler);
        }
    }
    
    private func onGetUSDToNZDCurrencyCompleted(result: Result<CurrencyHistoryEntity>, completionHandler: @escaping (Result<USDToNZDCurrency>) -> Void) {
        switch result {
        case .success(let entity):
            onGetUSDToNZDCurrencySuccess(entity: entity, completionHandler: completionHandler);
        case .failure(let error):
            completionHandler(Result.failure(error));
        }
    }
    
    private func onGetUSDToNZDCurrencySuccess(entity: CurrencyHistoryEntity, completionHandler: @escaping (Result<USDToNZDCurrency>) -> Void) {
        guard let model = ConvertUSDToNZDCurrency(from: entity) else {
            completionHandler(Result.failure(CurrencyRepositoryError.cannotFindCurrency))
            return;
        }
        
        completionHandler(Result.success(model));
    }
    
    private func ConvertUSDToNZDCurrency(from entity: CurrencyHistoryEntity) -> USDToNZDCurrency? {
        let quote = entity.quotes.first { (item) -> Bool in
            return item.currencyRatioName == CurrencyRepositoryImpl.USDToNZDCurrencyName;
        }
        guard let correctQuote = quote else {
            return nil
        }
        
        return USDToNZDCurrency.init(date: entity.date, ratio: correctQuote.ratio)
    }
}
