//
//  BasicHelper.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

/**
 A struct that provides utility methods.
 */
struct BasicHelper {
    
    // A static function that returns a string representation of the given value.
    static func toString(_ val: Any?) -> String? {
        if val == nil {
            return nil
        }
        
        if (val is String){
            return (val as! String)
        } else if (val is Int){
            return String(val as! Int)
        } else if (val is Double ) {
            return String(val as! Double)
        } else if (val is Float ) {
            return String(val as! Float)
        }
        return nil
    }
    
    // A static function that returns an integer representation of the given value.
    static func toInt(_ val: Any?) -> Int? {
        if val == nil {
            return nil
        }
        if (val is Int){
            return (val as! Int)
        }else if (val is String){
            return Int(val as! String)
        }
        return nil
    }
    
    // A static function that returns a double representation of the given value.
    static func toDouble(_ val: Any?) -> Double? {
        if val == nil {
            return nil
        }
        if (val is Double){
            return (val as! Double)
        }else if (val is String){
            return Double(val as! String)
        }
        return nil
    }
    
    // A static function that returns a bool representation of the given value.
    static func toBool(_ val: Any?) -> Bool {
        if val == nil {
            return false
        }
        if (val is Bool){
            return (val as! Bool)
        }
        return false
    }
    
    // A static function that returns initial from given name. Max 2 characters.
    static func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        var initials : [String] = []
        for component in components {
            
            if let firstLetter = component.first {
                initials.append(String(firstLetter))
            }
            if(initials.count >= 2){
                break
            }
        }
        return initials.joined().uppercased()
    }
    
    // A static function that convert date string into formatted date string. eg. monday 02:30pm, 3 weeks ago, 2 months ago, 1 year ago, etc..
    static func getFormattedDateForCard(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year) year\(year > 1 ? "s" : "") ago"
            } else if let month = components.month, month > 0 {
                return "\(month) month\(month > 1 ? "s" : "") ago"
            } else if let day = components.day {
                if(day > 7){
                    let week = day / 7
                    return "\(week) week\(week > 1 ? "s" : "") ago"
                } else if(day == 0 && components.hour == 0 &&  (components.minute ?? 0) < 5){
                    return "Just now"
                }
                else{
                    dateFormatter.dateFormat = "EEEE, hh:mma"
                    dateFormatter.amSymbol = "am"
                    dateFormatter.pmSymbol = "pm"
                    return "\(dateFormatter.string(from: date))"
                }
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    static func getFormattedDateForDueDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        }else{
            return ""
        }
    }
    
    static func getDateStringFromDate(from date: Date, dateFormat: String = "dd/MM/yyyy" ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
    
    static func getTimeStringFromDate(from date: Date, timeFormat: String = "hh:mm a" ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
    
    static func getFormattedDateTimeString(from date: Date, from time: Date, dateTimeFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String{
        
        // Create a Calendar instance
        let calendar = Calendar.current
        
        // Extract the time components (hour, minute, second) from the 'time' variable
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        // Create a new Date using the merged components
        if let mergedDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: timeComponents.second ?? 0, of: date) {
            //Format and convert date in desired dateFormat
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateTimeFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let formattedDateString = dateFormatter.string(from: mergedDate)
            return formattedDateString
        }
        
        return ""
    }
}
