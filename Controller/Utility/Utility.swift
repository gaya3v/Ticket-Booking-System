//
//  Utility.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 13/08/21.
//

import Foundation

class Utility {
    
    func generateRandomNumber(startRange : Int, endRange : Int) -> Int {
        let randomInt = Int.random(in: startRange...endRange)
        return randomInt
    }
    
    static func dateToString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    static func stringToDate(string: String) ->  Date
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = string.components(separatedBy: "/")
        
        if dateComponentArray.count == 3 {
            var components = DateComponents()
            components.year = Int(dateComponentArray[2])
            components.month = Int(dateComponentArray[1])
            components.day = Int(dateComponentArray[0])
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            guard let date = calendar.date(from: components) else {
                return (Date())
            }
            
            return (date)
        } else {
            return (Date())
        }
        
    }
    
    static func arrayToSpacedString(array: [Int]) -> String {
        var str = ""
        for element in array {
            str += String(element) + " "
        }
        return str
    }
}
