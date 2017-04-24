//
//  EPCalendarCell1.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 09/11/15.
//  Modified by Saravudh Sinsomros on Apr 18, 2017
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

enum SSCalendarCellType {
    case weekend
    case weekday
    case disable
    case hidden
}

class EPCalendarCell1: UICollectionViewCell {
    let PREDEFINED_CELL_COLOR:[SSCalendarCellType: (textColor: UIColor, bgColor:UIColor)] = [
        SSCalendarCellType.weekend: (textColor: EPDefaults.weekendTintColor, bgColor: UIColor.clear),
        SSCalendarCellType.weekday: (textColor: EPDefaults.weekdayTintColor, bgColor: UIColor.clear),
        SSCalendarCellType.disable: (textColor: EPDefaults.dayDisabledTintColor, bgColor: UIColor.clear),
        SSCalendarCellType.hidden: (textColor: UIColor.clear, bgColor: UIColor.clear)
    ]
    let TODAY_CELL_COLOR = (textColor: UIColor.white, bgColor: EPDefaults.todayTintColor)

    var isToday: Bool = false
    var currentDate: Date!
    var isCellSelectable: Bool?
    var type: SSCalendarCellType {
        didSet {
            self.lblDay.layer.backgroundColor = PREDEFINED_CELL_COLOR[self.type]!.bgColor.cgColor
            self.lblDay.textColor = PREDEFINED_CELL_COLOR[self.type]!.textColor
            if self.type == .disable {
                self.isCellSelectable = false
            } else {
                self.isCellSelectable = true
            }
        }
    }
    
    @IBOutlet weak var lblDay: UILabel!
    
    required public init?(coder aDecoder: NSCoder) {
        self.type = .hidden
        super.init(coder: aDecoder)
    }
    
    func selectedForLabelColor() {
        let color = EPDefaults.dateSelectionColor
        self.lblDay.layer.backgroundColor = color.cgColor
        self.lblDay.textColor = UIColor.white
    }

    func selectedIntervalCellForLabelColor() {
        let color = EPDefaults.intervalDateSelectionColor
        self.lblDay.layer.backgroundColor = color.cgColor
        self.lblDay.textColor = UIColor.white
    }
    
    func deSelectedForLabelColor() {
        if self.isToday {
            self.lblDay.layer.backgroundColor = TODAY_CELL_COLOR.bgColor.cgColor
            self.lblDay.textColor = TODAY_CELL_COLOR.textColor
        } else {
            self.lblDay.layer.backgroundColor = PREDEFINED_CELL_COLOR[self.type]!.bgColor.cgColor
            self.lblDay.textColor = PREDEFINED_CELL_COLOR[self.type]!.textColor
        }
    }
}
