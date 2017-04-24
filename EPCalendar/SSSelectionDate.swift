//
//  SSSelectionDate.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/18/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import UIKit

public enum SelectionType: Int {
    case single
    case multiple
    case range
}

public enum SSSelectedType: Int {
    case beginOrSelected
    case between
    case end
    case unselected
}

public class SSSelectionDate {
    private var minDate: Date
    private var maxDate: Date
    public var type: SelectionType
    fileprivate var arrSelectedDates = [Date]()
    
    init(selectionType: SelectionType, selectedDates: [Date]?, minDate: Date, maxDate: Date) {
        self.type = selectionType
        self.minDate = minDate
        self.maxDate = maxDate
        if let _ = selectedDates {
            for date in selectedDates! {
                self.addDate(date)
            }
        }
    }
    
    convenience init(selectionType: SelectionType, selectedDates: [Date]?) {
        let hundredYearTimeInterval: Double = 60 * 60 * 24 * 365 * 100
        self.init(selectionType: selectionType, selectedDates: selectedDates, minDate: Date(timeIntervalSinceNow: -hundredYearTimeInterval), maxDate: Date(timeIntervalSinceNow: hundredYearTimeInterval))
    }
    
    func removeDate(_ aDate: Date) {
        switch type {
        case .single, .multiple:
            self.arrSelectedDates = self.arrSelectedDates.filter(){
                return !($0.isDateSameDay(aDate))
            }
        case .range:
            if self.arrSelectedDates.contains(aDate) {
                if self.arrSelectedDates[0] == aDate {
                    self.arrSelectedDates.removeAll()
                } else {
                    self.arrSelectedDates.remove(at: 1)
                }
            }
        }
    }
    
    func addDate(_ aDate: Date) {
        if aDate >= self.minDate && aDate <= self.maxDate {
            switch type {
            case .single:
                self.arrSelectedDates.removeAll()
                self.arrSelectedDates.append(aDate)
            case .multiple:
                if minDate <= aDate && aDate <= maxDate && !self.arrSelectedDates.contains(aDate) {
                    self.arrSelectedDates.append(aDate)
                    self.arrSelectedDates.sort(by: { $0.compare($1) == .orderedDescending })
                }
            case .range:
                if self.arrSelectedDates.count == 0 {
                    self.arrSelectedDates.append(aDate)
                } else if self.arrSelectedDates.count == 1 {
                    if aDate < self.arrSelectedDates[0] {
                        self.arrSelectedDates[0] = aDate
                    } else if aDate > self.arrSelectedDates[0] {
                        self.arrSelectedDates.append(aDate)
                    }
                } else if self.arrSelectedDates.count == 2 {
                    self.arrSelectedDates.removeAll()
                    self.arrSelectedDates.append(aDate)
                }
            }
        }
    }
    
    func removeAll() {
        self.arrSelectedDates.removeAll()
    }
    
    func hasData() -> Bool {
        return self.arrSelectedDates.count > 0
    }
    
    var multipleDates: [Date] {
        get {
            return self.type == .multiple ? arrSelectedDates.map({$0}) : [Date]()
        }
    }
    
    var singleDate: Date? {
        return self.hasData() ? self.arrSelectedDates[0] : nil
    }
    
    var rangeDate: (begin: Date, end: Date?)? {
        get {
            if self.type == .range {
                if self.arrSelectedDates.count > 1 {
                    return (begin: self.arrSelectedDates[0], end: self.arrSelectedDates[1])
                } else if self.arrSelectedDates.count > 0 {
                    return (begin: self.arrSelectedDates[0], end: nil)
                }
            }
            return nil
        }
    }
    
    func isSelectedDate(date: Date) -> SSSelectedType {
        let isSelectedDate = self.arrSelectedDates.contains(date)
        if isSelectedDate {
            switch self.type {
            case .single, .multiple:
                return .beginOrSelected
            case .range:
                if self.arrSelectedDates[0] == date {
                    return .beginOrSelected
                } else if self.arrSelectedDates.count == 2 && self.arrSelectedDates[1] == date {
                    return .end
                }
            }
        } else {
            if self.type == .range, let rangeDate = self.rangeDate, let rangeDateEnd = rangeDate.end {
                if date > rangeDate.begin && date < rangeDateEnd {
                    return .between
                }
            }
        }
        return .unselected
    }
}
