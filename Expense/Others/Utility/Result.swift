//
//  Result.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import Foundation
enum Result<Value> {
    case success(Value)
    case failure(Error)
}
