//
//  EPCalendarPicker.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Modified by Saravudh Sinsomros on Apr 17, 2017.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

@objc public protocol EPCalendarPickerDelegate{
    @objc optional    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError)
    @objc optional    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : Date)
    @objc optional    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [Date])
}

open class EPCalendarPicker: UICollectionViewController {

    open var calendarDelegate : EPCalendarPickerDelegate?
    open var selectionDate: SSSelectionDate
    open var showsTodaysButton: Bool = true
    open var tintColor: UIColor
    
    open var dayDisabledTintColor: UIColor
    open var weekendTintColor: UIColor
    open var todayTintColor: UIColor
    open var monthTitleColor: UIColor
    
    // new options
    open var startDate: Date?
    open var hightlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = false
    open var barTintColor: UIColor
    
    open var backgroundImage: UIImage?
    open var backgroundColor: UIColor?
    
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    private var selectedCell: Set<IndexPath>
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // setup Navigationbar
        self.navigationController?.navigationBar.tintColor = self.tintColor
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:self.tintColor]

        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "EPCalendarCell1", bundle: Bundle(for: EPCalendarPicker.self )), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "EPCalendarHeaderView", bundle: Bundle(for: EPCalendarPicker.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        inititlizeBarButtons()

        DispatchQueue.main.async { () -> Void in
            self.scrollToToday()
        }
        
        if backgroundImage != nil {
            self.collectionView!.backgroundView =  UIImageView(image: backgroundImage)
        } else if backgroundColor != nil {
            self.collectionView?.backgroundColor = backgroundColor
        } else {
            self.collectionView?.backgroundColor = UIColor.white
        }
    }

    
    func inititlizeBarButtons(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(EPCalendarPicker.onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton

        var arrayBarButtons  = [UIBarButtonItem]()
        
        if self.selectionDate.type == .multiple {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EPCalendarPicker.onTouchDoneButton))
            arrayBarButtons.append(doneButton)
        }
        
        if showsTodaysButton {
            let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action:#selector(EPCalendarPicker.onTouchTodayButton))
            arrayBarButtons.append(todayButton)
            todayButton.tintColor = todayTintColor
        }
        
        self.navigationItem.rightBarButtonItems = arrayBarButtons
        
    }
    
    public convenience init(){
        self.init(startYear: EPDefaults.startYear, endYear: EPDefaults.endYear, selectionType: EPDefaults.selectionType, selectedDates: nil);
    }
    
    public convenience init(startYear: Int, endYear: Int) {
        self.init(startYear:startYear, endYear:endYear, selectionType: EPDefaults.selectionType, selectedDates: nil)
    }
    
    public convenience init(selectionType: SelectionType) {
        self.init(startYear: EPDefaults.startYear, endYear: EPDefaults.endYear, selectionType: selectionType, selectedDates: nil)
    }
    
    public convenience init(startYear: Int, endYear: Int, selectionType: SelectionType) {
        self.init(startYear: EPDefaults.startYear, endYear: EPDefaults.endYear, selectionType: selectionType, selectedDates: nil)
    }
    
    public init(startYear: Int, endYear: Int, selectionType: SelectionType, selectedDates: [Date]?) {
        self.startYear = startYear
        self.endYear = endYear
        self.selectedCell = Set()
        self.selectionDate = SSSelectionDate(selectionType: selectionType, selectedDates: selectedDates)
        
        //Text color initializations
        self.tintColor = EPDefaults.tintColor
        self.barTintColor = EPDefaults.barTintColor
        self.dayDisabledTintColor = EPDefaults.dayDisabledTintColor
        self.weekendTintColor = EPDefaults.weekendTintColor
        self.monthTitleColor = EPDefaults.monthTitleColor
        self.todayTintColor = EPDefaults.todayTintColor

        //Layout creation
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = EPDefaults.headerSize
        super.init(collectionViewLayout: layout)
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewDataSource

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if startYear > endYear {
            return 0
        }
        
        let numberOfMonths = 12 * (endYear - startYear) + 12
        return numberOfMonths
    }


    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(section)
        let addingPrefixDaysWithMonthDyas = ( firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - Calendar.current.firstWeekday )
        let addingSuffixDays = addingPrefixDaysWithMonthDyas%7
        var totalNumber  = addingPrefixDaysWithMonthDyas
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        
        return totalNumber
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EPCalendarCell1
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section)
        let prefixDays = (firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday)
        
        if indexPath.row >= prefixDays {
            cell.isCellSelectable = true
            let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row-prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth()-1)
            cell.currentDate = currentDate
            cell.lblDay.text = "\(currentDate.day())"
            
            // set cell type
            
            if startDate != nil && Calendar.current.startOfDay(for: cell.currentDate as Date) < Calendar.current.startOfDay(for: startDate!) {
                cell.type = .disable
            } else if (currentDate > nextMonthFirstDay) {
                cell.isCellSelectable = false
                if hideDaysFromOtherMonth {
                    cell.type = .hidden
                } else {
                    cell.type = .disable
                }
            } else  if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                cell.type = .weekend
            } else {
                cell.type = .weekday
            }
            
            if currentDate.isToday() && hightlightsToday {
                cell.isToday = true
            } else {
                cell.isToday = false
            }
            
            // end set cell type
            
            let isCellDateIsPresentDateFromNextMonth = (firstDayOfThisMonth.month() != currentDate.month())
            if self.selectionDate.isSelectedDate(date: currentDate) && !isCellDateIsPresentDateFromNextMonth {
                switch self.selectionDate.type {
                case .single:
                    break
                case .multiple:
                    self.selectedForLabelColor(cell: cell, indexPath: indexPath, isIntervalCell: false)
                case .range:
                    if self.selectionDate.isIntervalSelectedDate(date: currentDate) {
                        self.selectedForLabelColor(cell: cell, indexPath: indexPath, isIntervalCell: true)
                    } else {
                        self.selectedForLabelColor(cell: cell, indexPath: indexPath, isIntervalCell: false)
                    }
                }
            } else {
                self.deSelectedForLabelColor(cell: cell, indexPath: indexPath)
            }
        } else {
            self.deSelectedForLabelColor(cell: cell, indexPath: indexPath)
            cell.isCellSelectable = false
            let previousDay = firstDayOfThisMonth.dateByAddingDays(-( prefixDays - indexPath.row))
            cell.currentDate = previousDay
            cell.lblDay.text = "\(previousDay.day())"
            if hideDaysFromOtherMonth {
                cell.lblDay.textColor = UIColor.clear
            } else {
                cell.lblDay.textColor = self.dayDisabledTintColor
            }
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7
        return CGSize(width: screenWidth/7, height: screenWidth/7);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0); //top,left,bottom,right
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! EPCalendarHeaderView
            
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            
            header.lblTitle.text = firstDayOfMonth.monthNameFull()
            header.lblTitle.textColor = monthTitleColor
            header.updateWeekdaysLabelColor(EPDefaults.weekdayTintColor)
            header.updateWeekendLabelColor(weekendTintColor)
            header.backgroundColor = UIColor.white
            
            return header;
        }

        return UICollectionReusableView()
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EPCalendarCell1
        if cell.isCellSelectable! {
            switch self.selectionDate.type {
            case .single:
                calendarDelegate?.epCalendarPicker!(self, didSelectDate: cell.currentDate as Date)
                self.selectedForLabelColor(cell: cell, indexPath: indexPath, isIntervalCell: false)
                dismiss(animated: true, completion: nil)
                return
            case .multiple:
                if self.selectionDate.multipleDates.filter({ $0.isDateSameDay(cell.currentDate)
                }).count == 0 {
                    self.selectionDate.addDate(cell.currentDate)
                    self.selectedForLabelColor(cell: cell, indexPath: indexPath, isIntervalCell: false)
                } else {
                    self.selectionDate.removeDate(cell.currentDate)
                    self.deSelectedForLabelColor(cell: cell, indexPath: indexPath)
                }
            case .range:
                self.selectionDate.addDate(cell.currentDate)
                self.collectionView?.reloadSections([indexPath.section])
            }
        }
    }
    
    private func selectedForLabelColor(cell: EPCalendarCell1, indexPath: IndexPath, isIntervalCell: Bool) {
        if isIntervalCell {
            cell.selectedIntervalCellForLabelColor()
        } else {
            cell.selectedForLabelColor()
        }
        self.selectedCell.insert(indexPath)
    }
    
    private func deSelectedForLabelColor(cell: EPCalendarCell1, indexPath: IndexPath) {
        cell.deSelectedForLabelColor()
        self.selectedCell.remove(indexPath)
    }
    
    //MARK: Button Actions
    
    internal func onTouchCancelButton() {
       //TODO: Create a cancel delegate
        calendarDelegate?.epCalendarPicker!(self, didCancel: NSError(domain: "EPCalendarPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
        
    }
    
    internal func onTouchDoneButton() {
        //gathers all the selected dates and pass it to the delegate
        calendarDelegate?.epCalendarPicker!(self, didSelectMultipleDate: self.selectionDate.multipleDates)
        dismiss(animated: true, completion: nil)
    }

    internal func onTouchTodayButton() {
        scrollToToday()
    }
    
    
    open func scrollToToday () {
        let today = Date()
        scrollToMonthForDate(today)
    }
    
    open func scrollToMonthForDate (_ date: Date) {

        let month = date.month()
        let year = date.year()
        let section = ((year - startYear) * 12) + month
        let indexPath = IndexPath(row:1, section: section-1)
        
        self.collectionView?.scrollToIndexpathByShowingHeader(indexPath)
    }
    
    
}
