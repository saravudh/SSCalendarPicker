//
//  SSSelectionDate.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/18/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import UIKit

public enum SSSelectedType: Int {
    case beginOrSelected
    case between
    case end
    case unselected
}

public class SSSelectionDate {
    private var minDate: Date
    private var maxDate: Date
    private var beginDate: Date?
    private var endDate: Date?
    
    init(selectedDates: [Date]?, minDate: Date, maxDate: Date) {
        self.minDate = minDate
        self.maxDate = maxDate
        if let _ = selectedDates {
            for date in selectedDates! {
                self.addDate(date)
            }
        }
    }
    
    convenience init(selectedDates: [Date]?) {
        let hundredYearTimeInterval: Double = 60 * 60 * 24 * 365 * 100
        self.init(selectedDates: selectedDates, minDate: Date(timeIntervalSinceNow: -hundredYearTimeInterval), maxDate: Date(timeIntervalSinceNow: hundredYearTimeInterval))
    }
    
    func removeDate(_ aDate: Date) {
        if self.beginDate == aDate {
            self.beginDate = nil
        } else if endDate == aDate {
            self.endDate = nil
        }
    }
    
    func addDate(_ aDate: Date) {
        if aDate >= self.minDate && aDate <= self.maxDate {
            if let beginDate = self.beginDate {
                if self.endDate == nil {
                    if aDate < beginDate {
                        self.beginDate = aDate
                    } else if aDate > beginDate {
                        self.endDate = aDate
                    }
                } else {
                    self.beginDate = aDate
                    self.endDate = nil
                }
            } else {
                self.beginDate = aDate
            }
        }
    }
    
    func removeAll() {
        self.beginDate = nil
        self.endDate = nil
    }
    
    func hasData() -> Bool {
        return self.beginDate != nil
    }
    
    var rangeDate: (begin: Date, end: Date?)? {
        get {
            if let _ = self.beginDate {
                return (begin: self.beginDate!, end: self.endDate)
            }
            return nil
        }
    }
    
    func isSelectedDate(date: Date) -> SSSelectedType {
        if self.beginDate == date {
            return .beginOrSelected
        } else if self.endDate == date {
            return .end
        } else {
            if let rangeDate = self.rangeDate, let rangeDateEnd = rangeDate.end {
                if date > rangeDate.begin && date < rangeDateEnd {
                    return .between
                }
            }
        }
        return .unselected
    }
}
