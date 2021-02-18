//
//  HttpApiMock.swift
//  ExpenseTests
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
@testable import Expense

class HttpApiMock: HttpApi {
    var getFunctionUrl: String?
    var getFunctionParameters: [String : String]?
    var getFunctionExecutionCount: Int = 0

    
    func get(url: String, parameters: [String : String], completionHandler: @escaping (Result<[String : Any]>) -> Void) {
        getFunctionUrl = url;
        getFunctionParameters = parameters;
        getFunctionExecutionCount += 1;
    }
}
