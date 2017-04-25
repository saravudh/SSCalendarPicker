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
    fileprivate var arrSelectedDates = [Date]()
    
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
        if self.arrSelectedDates.contains(aDate) {
            if self.arrSelectedDates[0] == aDate {
                self.arrSelectedDates.removeAll()
            } else {
                self.arrSelectedDates.remove(at: 1)
            }
        }
    }
    
    func addDate(_ aDate: Date) {
        if aDate >= self.minDate && aDate <= self.maxDate {
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
    
    func removeAll() {
        self.arrSelectedDates.removeAll()
    }
    
    func hasData() -> Bool {
        return self.arrSelectedDates.count > 0
    }
    
    var rangeDate: (begin: Date, end: Date?)? {
        get {
            if self.arrSelectedDates.count > 1 {
                return (begin: self.arrSelectedDates[0], end: self.arrSelectedDates[1])
            } else if self.arrSelectedDates.count > 0 {
                return (begin: self.arrSelectedDates[0], end: nil)
            }
            return nil
        }
    }
    
    func isSelectedDate(date: Date) -> SSSelectedType {
        let isSelectedDate = self.arrSelectedDates.contains(date)
        if isSelectedDate {
            if self.arrSelectedDates[0] == date {
                return .beginOrSelected
            } else if self.arrSelectedDates.count == 2 && self.arrSelectedDates[1] == date {
                return .end
            }
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
