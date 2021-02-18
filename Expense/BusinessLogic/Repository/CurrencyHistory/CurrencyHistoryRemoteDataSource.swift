//
//  CurrencyRemoteDataSource.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
enum CurrencyHistoryRemoteDataSourceError: Error {
    case InvalidDate
    case requestFailure
    case unexpected
}

protocol CurrencyHistoryRemoteDataSource {
    func get(date: Date, completion: @escaping (Result<CurrencyHistoryEntity>) -> Void)
}

class CurrencyHistoryRemoteDataSourceImpl: CurrencyHistoryRemoteDataSource {
    static let invalidDateHttpStatusCode = 302;
    
    static let parameterKeyAccessKey = "access_key";
    static let parameterKeyCurrencies = "currencies";
    static let parameterKeyDate = "date";
    static let dateFormat = "yyyy-MM-dd";
    
    static let parameterValueAccessKey = "07db450a67148cfd918aa2a64c8ff4ca";
    static let parameterValueCurrencies = "NZD";
    
    let httpApi: HttpApi
    
    init(_ httpApi: HttpApi) {
        self.httpApi = httpApi;
    }
    func get(date: Date, completion: @escaping (Result<CurrencyHistoryEntity>) -> Void) {
        let parameters = createParameters(date: date);
        
        httpApi.get(url: Constant.Url.CurrencyHistory, parameters: parameters) { [weak self] (result) in
            self?.onGetRequestCompletion(result: result, completion: completion)
        };
    }
    
    private func createParameters(date: Date) -> [String: String] {
        let dateString = date.toUTCString(format: CurrencyHistoryRemoteDataSourceImpl.dateFormat);
        
        let parameters: [String: String] = [
            CurrencyHistoryRemoteDataSourceImpl.parameterKeyAccessKey: CurrencyHistoryRemoteDataSourceImpl.parameterValueAccessKey,
            CurrencyHistoryRemoteDataSourceImpl.parameterKeyCurrencies: CurrencyHistoryRemoteDataSourceImpl.parameterValueCurrencies,
            CurrencyHistoryRemoteDataSourceImpl.parameterKeyDate: dateString,
        ]
        return parameters;
    }
    
    private func onGetRequestCompletion(result: Result<[String:Any]>, completion: @escaping (Result<CurrencyHistoryEntity>) -> Void) {
        switch result {
        case .success(let dictionary):
            if let entity = CurrencyHistoryEntity.fromDictionary(dict: dictionary)  {
                completion(Result.success(entity))
                return;
            }
            
            let error = validateError(responseDictionary: dictionary)
            completion(Result.failure(error));
        case .failure(_):
            completion(Result.failure(CurrencyHistoryRemoteDataSourceError.unexpected))
        }
    }
    
    private func validateError(responseDictionary: [String : Any]) -> CurrencyHistoryRemoteDataSourceError {
        guard let error = responseDictionary["error"] as? [String:Any],
              let code = error["code"] as? Int
        else {
            return CurrencyHistoryRemoteDataSourceError.unexpected;
        }
        
        return code == CurrencyHistoryRemoteDataSourceImpl.invalidDateHttpStatusCode ? CurrencyHistoryRemoteDataSourceError.InvalidDate : CurrencyHistoryRemoteDataSourceError.unexpected;
    }
}
