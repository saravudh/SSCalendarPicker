//
//  SSCalendarPickerViewController.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/24/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import UIKit

class SSCalendarPickerViewController: UIViewController, SSSelectionDateChangeDelegate {
    var calendarDelegate: EPCalendarPickerDelegate?
    var startYear: Int = EPDefaults.startYear
    var endYear: Int = EPDefaults.endYear
    var startDate: Date = EPDefaults.startDate
    open var showsTodaysButton: Bool = true
    open var todayTintColor: UIColor = EPDefaults.todayTintColor
    private var epCalendar: EPCalendarPicker?
    var tintColor: UIColor = EPDefaults.tintColor
    open var selectionDate: SSSelectionDate = SSSelectionDate(selectedDates: nil)

    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var lblFourth: UILabel!
    @IBOutlet weak var lblFifth: UILabel!
    @IBOutlet weak var lblSixth: UILabel!
    @IBOutlet weak var lblSeventh: UILabel!
    @IBOutlet weak var lblDepartTitle: UILabel!
    @IBOutlet weak var lblDepartDate: UILabel!
    @IBOutlet weak var lblReturnTitle: UILabel!
    @IBOutlet weak var lblReturnDate: UILabel!

    func dateDidChange() {
        if let beginDate = self.selectionDate.departDate {
            self.lblDepartDate.text = beginDate.dateString()
            self.lblDepartTitle.textColor = self.tintColor
        } else {
            self.lblDepartDate.text = ""
            self.lblDepartTitle.textColor = UIColor.lightGray
        }
        if let endDate = self.selectionDate.returnDate {
            self.lblReturnDate.text = endDate.dateString()
            self.lblReturnTitle.textColor = self.tintColor
        } else {
            self.lblReturnDate.text = ""
            self.lblReturnTitle.textColor = UIColor.lightGray
        }
    }
    
    func setupColor() {
        self.lblDepartDate.textColor = self.tintColor
        self.lblReturnDate.textColor = self.tintColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EPCalendarPickerSegue" {
            if let calendarPicker = segue.destination as? EPCalendarPicker {
                self.selectionDate.delegate = self
                self.epCalendar = calendarPicker
                inititlizeBarButtons()
                calendarPicker.inititlizeProperties(startYear: self.startYear, endYear: self.endYear)
                calendarPicker.calendarDelegate = self.calendarDelegate
                calendarPicker.startDate = self.startDate
                calendarPicker.hightlightsToday = true
                calendarPicker.hideDaysFromOtherMonth = true
                calendarPicker.cover = self
                //calendarPicker.barTintColor = UIColor.greenColor()
                calendarPicker.dayDisabledTintColor = UIColor.gray
                self.updateWeekdaysLabelColor(EPDefaults.weekdayTintColor)
                self.updateWeekendLabelColor(EPDefaults.weekendTintColor)
                self.setDayHeader()
                self.dateDidChange()
                self.setupColor()
            }
        }
    }
    
    func inititlizeBarButtons(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self.epCalendar, action: #selector(EPCalendarPicker.onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        var arrayBarButtons  = [UIBarButtonItem]()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTouchDoneButton))
        arrayBarButtons.append(doneButton)
        
        if showsTodaysButton {
            let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self.epCalendar, action:#selector(EPCalendarPicker.onTouchTodayButton))
            arrayBarButtons.append(todayButton)
            todayButton.tintColor = todayTintColor
        }
        self.navigationItem.rightBarButtonItems = arrayBarButtons
    }
    
    internal func onTouchDoneButton() {
        //gathers all the selected dates and pass it to the delegate
        dismiss(animated: true, completion: nil)
    }
    
    private func setDayHeader() {
        let calendar = Calendar.current
        let weeksDayList = calendar.shortWeekdaySymbols
        
        if Calendar.current.firstWeekday == 2 {
            lblFirst.text = weeksDayList[1]
            lblSecond.text = weeksDayList[2]
            lblThird.text = weeksDayList[3]
            lblFourth.text = weeksDayList[4]
            lblFifth.text = weeksDayList[5]
            lblSixth.text = weeksDayList[6]
            lblSeventh.text = weeksDayList[0]
        } else {
            lblFirst.text = weeksDayList[0]
            lblSecond.text = weeksDayList[1]
            lblThird.text = weeksDayList[2]
            lblFourth.text = weeksDayList[3]
            lblFifth.text = weeksDayList[4]
            lblSixth.text = weeksDayList[5]
            lblSeventh.text = weeksDayList[6]
        }
    }
    
    func updateWeekendLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 2 {
            lblSixth.textColor = color
            lblSeventh.textColor = color
        } else {
            lblFirst.textColor = color
            lblSeventh.textColor = color
        }
    }
    
    func updateWeekdaysLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 2 {
            lblFirst.textColor = color
            lblSecond.textColor = color
            lblThird.textColor = color
            lblFourth.textColor = color
            lblFifth.textColor = color
        } else {
            lblSecond.textColor = color
            lblThird.textColor = color
            lblFourth.textColor = color
            lblFifth.textColor = color
            lblSixth.textColor = color
        }
    }
}
