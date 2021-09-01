//
//  Extensions.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import UIKit

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Date {
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
}

extension String {
    func toAttributed(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return toAttributed(attributes: [.paragraphStyle: paragraphStyle])
    }

    func toAttributed(attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        if let date = formatter.date(from: self) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
    
    private static let formatter = NumberFormatter()

        func clippingCharacters(in characterSet: CharacterSet) -> String {
            components(separatedBy: characterSet).joined()
        }

        func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
            let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
            guard !digits.isEmpty else { return self }

            Self.formatter.locale = locale
            let maps: [(original: String, converted: String)] = digits.map {
                let original = String($0)
                guard let digit = Self.formatter.number(from: String($0)) else {
                    assertionFailure("Can not convert to number from: \(original)")
                    return (original, original)
                }
                guard let localized = Self.formatter.string(from: digit) else {
                    assertionFailure("Can not convert to string from: \(digit)")
                    return (original, original)
                }
                return (original, localized)
            }

            var converted = self
            for map in maps { converted = converted.replacingOccurrences(of: map.original, with: map.converted) }
            return converted
        }
    
    func toLatin() -> String {
        return self.convertedDigitsToLocale(Locale(identifier: "EN"))
    }
}

extension Date {
    // "yyyy-MM-dd HH:mm"
    // "yyyy-MM-dd h:mm a"
    func toString(format:String = "yyyy-MM-dd") -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = format

        // Convert Date to String
        return dateFormatter.string(from: self)
    }
    
    func toUTC() -> String {
        return ISO8601DateFormatter().string(from: self)
    }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
