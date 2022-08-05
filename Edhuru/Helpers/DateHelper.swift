//
//  DateHelper.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import Foundation

class DateHelper {
    
    static func chatTimestampFrom(date: Date?) -> String {
        guard date != nil else {
            return ""
        }
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        
        return df.string(from: date!)
    }
}
