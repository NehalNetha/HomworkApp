//
//  DateUtils.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 20/06/24.
//

import Foundation


struct DateUtils {
    static func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Format for getting the day of the week
        return dateFormatter.string(from: Date())
    }

    static func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Format for getting the day of the month
        return dateFormatter.string(from: Date())
    }

    static func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Format for getting the month
        return dateFormatter.string(from: Date())
    }
    
    static func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
    }
    
    static func timeString(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            return formatter.string(from: date)
    }
}
