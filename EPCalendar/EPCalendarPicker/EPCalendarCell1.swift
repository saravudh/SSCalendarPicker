//
//  EPCalendarCell1.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 09/11/15.
//  Modified by Saravudh Sinsomros on Apr 18, 2017
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

struct SSCalendarCellType {
    let textColor: UIColor
    var bgColor: UIColor
    static let today = SSCalendarCellType(textColor: UIColor.white, bgColor: EPDefaults.todayTintColor)
    static let weekend = SSCalendarCellType(textColor: EPDefaults.weekendTintColor, bgColor: UIColor.clear)
    static let weekday = SSCalendarCellType(textColor: EPDefaults.weekdayTintColor, bgColor: UIColor.clear)
    static let disable = SSCalendarCellType(textColor: EPDefaults.dayDisabledTintColor, bgColor: UIColor.clear)
    static let hidden = SSCalendarCellType(textColor: UIColor.clear, bgColor: UIColor.clear)
}

class EPCalendarCell1: UICollectionViewCell {

    var currentDate: Date!
    var isCellSelectable: Bool?
    var type: SSCalendarCellType {
        didSet {
            self.lblDay.layer.backgroundColor = self.type.bgColor.cgColor
            self.lblDay.textColor = self.type.textColor
        }
    }
    
    @IBOutlet weak var lblDay: UILabel!
    
    required public init?(coder aDecoder: NSCoder) {
        self.type = SSCalendarCellType.hidden
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selectedForLabelColor() {
        let color = EPDefaults.dateSelectionColor
        self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width/2
        self.lblDay.layer.backgroundColor = color.cgColor
        self.lblDay.textColor = UIColor.white
    }

    func selectedIntervalCellForLabelColor() {
        let color = EPDefaults.intervalDateSelectionColor
        self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width/2
        self.lblDay.layer.backgroundColor = color.cgColor
        self.lblDay.textColor = UIColor.white
    }
    
    func deSelectedForLabelColor() {
        self.lblDay.layer.backgroundColor = self.type.bgColor.cgColor
        self.lblDay.textColor = self.type.textColor
    }
}
