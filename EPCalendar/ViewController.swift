//
//  ViewController.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EPCalendarPickerDelegate {

    @IBOutlet weak var txtViewDetail: UITextView!
    @IBOutlet weak var btnShowMeCalendar: UIButton!

    @IBAction func onTouchShowMeCalendarButton(_ sender: AnyObject) {        
        let calendarPicker = UIStoryboard(name: "SSCalendarPicker", bundle: nil).instantiateInitialViewController() as! SSCalendarPickerViewController
        
        calendarPicker.calendarDelegate = self
        calendarPicker.startYear = 2016
        calendarPicker.endYear = 2017
        calendarPicker.startDate = Date()
        calendarPicker.title = "Date Picker"

        
        
        
        
//        calendarPicker.backgroundImage = UIImage(named: "background_image")
//        calendarPicker.backgroundColor = UIColor.blueColor()
        
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.present(navigationController, animated: true, completion: nil)   
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError) {
        txtViewDetail.text = "User cancelled selection"
        
    }

    func epCalendarPicker(_: EPCalendarPicker, didSelectDate dates : (begin: Date, end: Date?)?) {
        txtViewDetail.text = "User selected dates: \n\(String(describing: dates?.begin)) : \(String(describing: dates?.end))"
    }

}

