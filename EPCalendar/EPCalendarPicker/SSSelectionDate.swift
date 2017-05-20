//
//  SSSelectionDate.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/18/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import UIKit

public protocol SSSelectionDateChangeDelegate {
    func dateDidChange()
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
    fileprivate(set) open var departDate: Date? {
        didSet {
            delegate?.dateDidChange()
        }
    }
    fileprivate(set) open var returnDate: Date? {
        didSet {
            delegate?.dateDidChange()
        }
    }
    public var delegate: SSSelectionDateChangeDelegate?
    
    init(departDate: Date?, returnDate: Date?, minDate: Date, maxDate: Date) {
        self.minDate = minDate
        self.maxDate = maxDate
        if let _ = departDate {
            self.departDate = departDate
        }
        
        if let _ = returnDate {
            self.returnDate = returnDate
        }
    }
    
    convenience init(minDate: Date, maxDate: Date) {
        self.init(departDate: nil, returnDate: nil, minDate: minDate, maxDate: maxDate)
    }
    
    func removeDate(_ aDate: Date) {
        if self.departDate == aDate {
            self.departDate = nil
        } else if returnDate == aDate {
            self.returnDate = nil
        }
    }
    
    func addDate(_ aDate: Date) {
        if aDate >= self.minDate && aDate <= self.maxDate {
            if let departDate = self.departDate {
                if self.returnDate == nil {
                    if aDate < departDate {
                        self.departDate = aDate
                    } else if aDate >= departDate {
                        self.returnDate = aDate
                    }
                } else {
                    self.departDate = aDate
                    self.returnDate = nil
                }
            } else {
                self.departDate = aDate
            }
        }
    }
    
    func removeAll() {
        self.departDate = nil
        self.returnDate = nil
    }
    
    func hasData() -> Bool {
        return self.departDate != nil
    }
    
    var rangeDate: (departDate: Date, returnDate: Date?)? {
        get {
            if let _ = self.departDate {
                return (departDate: self.departDate!, returnDate: self.returnDate)
            }
            return nil
        }
    }
    
    func isSelectedDate(date: Date) -> SSSelectedType {
        if self.departDate == date {
            return .beginOrSelected
        } else if self.returnDate == date {
            return .end
        } else {
            if let rangeDate = self.rangeDate, let returnDate = rangeDate.returnDate {
                if date > rangeDate.departDate && date < returnDate {
                    return .between
                }
            }
        }
        return .unselected
    }
}
