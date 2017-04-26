//
//  SSCalendarPickerViewController.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/24/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import UIKit

public protocol SSCalendarPickerDelegate{
    func ssCalendarPicker(didCancel error : NSError)
    func ssCalendarPicker(didSelectDate dates : (departDate: Date, returnDate: Date?)?)
}

class SSCalendarPickerViewController: UIViewController, SSSelectionDateChangeDelegate {
    var calendarDelegate: SSCalendarPickerDelegate?
    var startMonth: Int = EPDefaults.startMonth
    var startYear: Int = EPDefaults.startYear
    var endYear: Int = EPDefaults.endYear
    var startDate: Date = EPDefaults.startDate
    private var epCalendar: EPCalendarPicker?

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
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnDoneCoverView: UIView!

    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    func dateDidChange() {
        if let beginDate = self.selectionDate.departDate {
            self.lblDepartDate.text = beginDate.dateString()
            self.lblDepartTitle.textColor = EPDefaults.tintColor
        } else {
            self.lblDepartDate.text = ""
            self.lblDepartTitle.textColor = UIColor.lightGray
        }
        if let endDate = self.selectionDate.returnDate {
            self.lblReturnDate.text = endDate.dateString()
            self.lblReturnTitle.textColor = EPDefaults.tintColor
        } else {
            self.lblReturnDate.text = ""
            self.lblReturnTitle.textColor = UIColor.lightGray
        }
        self.refreshDoneButton()
    }
    
    @IBAction func btnDepartAction(_ sender: UIButton) {
        if let departDate = self.selectionDate.departDate {
            self.epCalendar?.scrollToMonthForDate(departDate)
        }
    }
    
    @IBAction func btnReturnAction(_ sender: UIButton) {
        if let returnDate = self.selectionDate.returnDate {
            self.epCalendar?.scrollToMonthForDate(returnDate)
        }
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        calendarDelegate?.ssCalendarPicker(didSelectDate: (departDate:self.selectionDate.departDate!, returnDate:self.selectionDate.returnDate))
        dismiss(animated: true, completion: nil)
    }
    
    internal func onTouchCancelButton() {
        //TODO: Create a cancel delegate
        calendarDelegate?.ssCalendarPicker(didCancel: NSError(domain: "EPCalendarPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
    }
    
    func setupColor() {
        self.lblDepartDate.textColor = EPDefaults.tintColor
        self.lblReturnDate.textColor = EPDefaults.tintColor
    }
    
    private func refreshDoneButton() {
        if let _ = self.selectionDate.departDate {
            let btnTitle = (self.selectionDate.returnDate == nil) ? "ONE WAY" : "DONE"
            self.btnDone.setTitle(btnTitle, for: UIControlState.normal)
            self.btnDoneCoverView.isHidden = false
            self.btnHeight.constant = 60
        } else {
            self.btnDoneCoverView.isHidden = true
            self.btnHeight.constant = 0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EPCalendarPickerSegue" {
            if let calendarPicker = segue.destination as? EPCalendarPicker {
                self.selectionDate.delegate = self
                self.epCalendar = calendarPicker
                inititlizeBarButtons()
                self.refreshDoneButton()
                calendarPicker.inititlizeProperties(startMonth: self.startMonth, startYear: self.startYear, endYear: self.endYear)
                calendarPicker.startDate = self.startDate
                calendarPicker.hightlightsToday = true
                calendarPicker.hideDaysFromOtherMonth = true
                calendarPicker.cover = self
                //calendarPicker.barTintColor = UIColor.greenColor()
                calendarPicker.dayDisabledTintColor = UIColor.gray
                self.updateDayLabelColor()
                self.setDayHeader()
                self.dateDidChange()
                self.setupColor()
            }
        }
    }
    
    func inititlizeBarButtons(){
        self.btnDone.tintColor = UIColor.white
        self.btnDoneCoverView.backgroundColor = EPDefaults.tintColor
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self.epCalendar, action: #selector(onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self.epCalendar, action:#selector(EPCalendarPicker.onTouchTodayButton))
        todayButton.tintColor = EPDefaults.todayTintColor
        self.navigationItem.rightBarButtonItem = todayButton
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
    
    func updateDayLabelColor() {
        lblFirst.textColor = EPDefaults.dayLabelColor
        lblSecond.textColor = EPDefaults.dayLabelColor
        lblThird.textColor = EPDefaults.dayLabelColor
        lblFourth.textColor = EPDefaults.dayLabelColor
        lblFifth.textColor = EPDefaults.dayLabelColor
        lblSixth.textColor = EPDefaults.dayLabelColor
        lblSeventh.textColor = EPDefaults.dayLabelColor
    }
}
