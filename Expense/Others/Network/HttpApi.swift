//
//  HttpApi.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import Alamofire

protocol HttpApi {
    func get(url: String, parameters: [String : String], completionHandler: @escaping (Result<[String: Any]>) -> Void);
}

class HttpApiImpl : HttpApi {
    func get(url: String, parameters: [String : String], completionHandler: @escaping (Result<[String: Any]>) -> Void) {
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let json):
                let response = json as? [String : Any];
                if response != nil {
                    completionHandler(.success(response!))
                } else {
                    completionHandler(.failure(NSError.init(domain: "Http no response error", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
