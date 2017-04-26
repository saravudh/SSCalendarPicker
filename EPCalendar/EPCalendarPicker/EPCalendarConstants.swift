//
//  EPCalendarConstants.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

struct EPDefaults  {
    //Values
    static let startMonth = 1
    static let startYear = 2015
    static let endYear = 2016
    static let startDate = Date(year : 2017, month : 1, day : 1)
    
    //Colors
    static let dayDisabledTintColor = UIColor.lightGray
    static let weekdayTintColor = EPColors.lightBlack
    static let weekendTintColor = EPColors.lightBlack
    static let dateSelectionColor = EPColors.greenShorsher
    static let intervalDateSelectionColor = EPColors.lightGreenShorsher
    static let monthTitleColor = UIColor.darkGray
    static let todayTintColor = EPColors.greenShorsher
    static let dayLabelColor = UIColor.gray
    
    static let tintColor = EPColors.greenShorsher
    static let barTintColor = UIColor.white
    
    //HeaderSize
    static let headerSize = CGSize(width: 100,height: 60)
}

struct EPColors {
    static let greenShorsher = UIColor(red: 85 / 255.0, green: 147 / 255.0, blue: 59 / 255.0, alpha: 1.0)
    static let lightGreenShorsher = UIColor(red: 151 / 255.0, green: 188 / 255.0, blue: 100 / 255.0, alpha: 1.0)
    static let lightBlack = UIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1.0)
    static let BlueColor = UIColor(red: (0/255), green: (21/255), blue: (63/255), alpha: 1.0)
    static let YellowColor = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
    static let LightGrayColor = UIColor(red: (230/255), green: (230/255), blue: (230/255), alpha: 1.0)
    static let OrangeColor = UIColor(red: (233/255), green: (159/255), blue: (94/255), alpha: 1.0)
    static let LightGreenColor = UIColor(red: (158/255), green: (206/255), blue: (77/255), alpha: 1.0)
    
    static let EmeraldColor = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
    static let SunflowerColor = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
    static let PumpkinColor = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
    static let AsbestosColor = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
    static let AmethystColor = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
    static let PeterRiverColor = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
    static let PeterRiverLightColor = UIColor(red: (100/255), green: (200/255), blue: (255/255), alpha: 1.0)
    static let PomegranateColor = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
}


