//
//  DateTimeHelper.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-03.
//

import Foundation

// Helper functions related to date and time.
class DateTimeHelper {
    
    static var isoDateFormatter = ISO8601DateFormatter()
    static var monthDayYearFormatter = DateTimeHelper.getMonthDayYearFormatter()
    
    static func getMonthDayYearString(isoDateString: String) -> String? {
        if let parsedDate = isoDateFormatter.date(from: isoDateString) {
            return monthDayYearFormatter.string(from: parsedDate)
        }
        return nil
    }
    
    private static func getMonthDayYearFormatter() -> DateFormatter {
        let monthDayYearFormatter = DateFormatter()
        monthDayYearFormatter.dateFormat = "MMM dd, yyyy"
        return monthDayYearFormatter
    }
    
}
