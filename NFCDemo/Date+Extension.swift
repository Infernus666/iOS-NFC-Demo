//
//  Date+Extension.swift
//  skincoach
//
//  Created by Achin Kumar on 26/02/18.
//  Copyright © 2018 vinsol. All rights reserved.
//

import Foundation

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension Date {
    var DDMMYY  : String { return self.string(withFormat: "dd/MM/yyyy") }
    var MMDDYY  : String { return self.string(withFormat: "MM/dd/yy") }
    var MMMM    : String { return self.string(withFormat: "MMMM") }
    var MMMMYYYY: String { return self.string(withFormat: "MMMM, yyyy") }
    var HHMMA   : String { return self.string(withFormat: "hh:mma") }
    var HHMMssSS: String { return self.string(withFormat: "HH:mm:ss.SS") }
    
    
    public func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    var startOfWeek: Date { return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))! }
    var endOfWeek: Date { return Calendar.current.date(byAdding: .day, value: 7, to: self.startOfWeek)! }
    
    var startOfMonth: Date { return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))! }
    var endOfMonth: Date { return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)! }
    
    var startOfDay:Date { return self.midnight }
    var startOfNextDay: Date { return self.plus(days: 1).midnight }
    
    var daysFromToday: Int { return Date.daysBetween(date1: Date(), date2: self) }
    
    var timeOfDay: String {
        if hour >= 1 && hour < 10 { return "Morning" }
        if hour >= 10 && hour < 16 { return "Afternoon" }
        if hour >= 16 && hour < 21 { return "Evening" }
        if hour >= 21 && hour < 24 { return "Night" }
        else { return "Late Night" }
    }
    
    
    func same(date: Date) -> Bool { return date.year == self.year && date.dayOfYear == self.dayOfYear }
    func sameYear(date: Date) -> Bool { return date.year == self.year }
    func sameWeek(date: Date) -> Bool { return self.startOfWeek.same(date: date.startOfWeek) }
    func sameMonth(date: Date) -> Bool { return self.startOfMonth.same(date: date.startOfMonth) }
    
    func copy(hour: Int? = nil, minute: Int? = nil) -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        if let hour = hour { dc.hour = hour }
        if let minute = minute { dc.minute = minute }
        return Calendar.current.date(from: dc)!
    }
    
    
    
    // **********************************************************************************************
    // As taken from : https://github.com/al7/SwiftDateExtension/blob/master/DateExtension/DateExtension.swift
    // **********************************************************************************************
    
    public func plus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int = 0, minutes min: Int = 0, hours hrs: Int = 0, days d: Int = 0, weeks wks: Int = 0, months mts: Int = 0, years yrs: Int = 0) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    public var midnight: Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        return Calendar.current.date(from: dc)!
    }
    
    public var midnightUTC: Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    //MARK- Computed Properties
    
    public var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }
    
    public var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self))
    }
    
    public var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self))
    }
    
    public var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self))
    }
    
    public var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self))
    }
    
    public var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self))
    }
    
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    var dayOfWeek: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    var daysInMonth: Int {
        return Calendar.current.range(of: .day, in: .month, for: self)!.count
    }
}














