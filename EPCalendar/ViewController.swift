//
//  ViewController.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SSCalendarPickerDelegate {

    @IBOutlet weak var txtViewDetail: UITextView!
    @IBOutlet weak var btnShowMeCalendar: UIButton!

    @IBAction func onTouchShowMeCalendarButton(_ sender: AnyObject) {        
        let calendarPicker = UIStoryboard(name: "SSCalendarPicker", bundle: nil).instantiateInitialViewController() as! SSCalendarPickerViewController
        
        calendarPicker.calendarDelegate = self
        calendarPicker.startMonth = 8
        calendarPicker.startYear = 2016
        calendarPicker.endYear = 2017
        calendarPicker.startDate = Date()
        calendarPicker.title = "Date PickerXX"
        
        calendarPicker.setSelected(date :(departDate: Date(year: 2017, month: 4, day: 26), returnDate: Date(year: 2017, month: 4, day: 26)))
        
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.present(navigationController, animated: true, completion: nil)   
    }
    
    func ssCalendarPicker(didCancel error : NSError) {
        txtViewDetail.text = "User cancelled selection"
        
    }

    func ssCalendarPicker(didSelectDate dates : (departDate: Date, returnDate: Date?)?) {
        txtViewDetail.text = "User selected dates: \n\(String(describing: dates?.departDate)) : \(String(describing: dates?.returnDate))"
    }

}

