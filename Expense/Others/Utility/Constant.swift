//
//  Constant.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
struct Constant {
    struct MoneyFormat {
        static let General = "%.2f"
    }
    
    struct Url {
        static let CurrencyHistory = "http://api.currencylayer.com/historical"
    }
    
    struct DateFormat {
        static let utc = "UTC";
        static let yyyyMMddDash = "yyyy-MM-dd";
        static let yyyyMMMddHHmm = "yyyy-MM-dd HH:mm";
    }
}
