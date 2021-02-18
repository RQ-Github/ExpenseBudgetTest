//
//  DateExtensions.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation

extension Date {
    func toUTCString(format: String) -> String {
        let timeZone = TimeZone(abbreviation: Constant.DateFormat.utc);
        let dateFormatter = Date.createDateFormatter(format: format, timeZone: timeZone)
        return dateFormatter.string(from: self);
    }
    
    func toString(format: String) -> String {
        let dateFormatter = Date.createDateFormatter(format: format, timeZone: nil)
        return dateFormatter.string(from: self);
    }
    
    static func fromString(_ dateString:String, format: String) -> Self? {
        let dateFormatter = Date.createDateFormatter(format: format, timeZone: nil)
        return dateFormatter.date(from: dateString);
    }
    
    static func fromUTCString(_ dateString:String, format: String) -> Self? {
        let timeZone = TimeZone(abbreviation: Constant.DateFormat.utc);
        let dateFormatter = Date.createDateFormatter(format: format, timeZone: timeZone)
        return dateFormatter.date(from: dateString);
    }
    
    static func createDateFormatter(format: String, timeZone: TimeZone?) -> DateFormatter {
        let dateFormatter = DateFormatter.init();
        dateFormatter.dateFormat = format;
        
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone;
        }
        
        return dateFormatter
    }
}
