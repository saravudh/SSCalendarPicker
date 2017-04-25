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

public protocol EPCalendarPickerDelegate{
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError)
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate dates : (begin: Date, end: Date?)?)
}

open class EPCalendarPicker: UICollectionViewController {

    open var calendarDelegate : EPCalendarPickerDelegate?
    open var selectionDate: SSSelectionDate
    
    open var dayDisabledTintColor: UIColor
    open var monthTitleColor: UIColor
    
    // new options
    open var startDate: Date?
    open var hightlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = false
    open var barTintColor: UIColor
    
    open var backgroundImage: UIImage?
    open var backgroundColor: UIColor?
    var cover: SSCalendarPickerViewController?
    
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //Layout creation
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.headerReferenceSize = EPDefaults.headerSize
        self.collectionView?.collectionViewLayout = layout
        
        // setup Navigationbar
        self.navigationController?.navigationBar.tintColor = self.cover?.tintColor
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:self.cover?.tintColor ?? EPDefaults.tintColor]

        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "EPCalendarCell1", bundle: Bundle(for: EPCalendarPicker.self )), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "EPCalendarHeaderView", bundle: Bundle(for: EPCalendarPicker.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
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

    public func inititlizeProperties(startYear: Int, endYear: Int, selectedDates: [Date]?) {
        self.startYear = startYear
        self.endYear = endYear
        self.selectionDate = SSSelectionDate(selectedDates: selectedDates)
    }    

    required public init?(coder aDecoder: NSCoder) {
        self.selectionDate = SSSelectionDate(selectedDates: nil)
        self.startYear = EPDefaults.startYear
        self.endYear = EPDefaults.endYear

        //Text color initializations
        self.barTintColor = EPDefaults.barTintColor
        self.dayDisabledTintColor = EPDefaults.dayDisabledTintColor
        self.monthTitleColor = EPDefaults.monthTitleColor
        super.init(coder: aDecoder)
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
            let isSelected = self.selectionDate.isSelectedDate(date: currentDate)
            if (isSelected != .unselected) && !isCellDateIsPresentDateFromNextMonth {
                switch isSelected {
                case .between:
                    cell.selectedIntervalCellForLabelColor()
                case .beginOrSelected:
                    cell.selectedForLabelColor()
                case .end:
                    cell.selectedForLabelColor()
                default:
                    break
                }
            } else {
                cell.deSelectedForLabelColor()
            }
        } else {
            cell.deSelectedForLabelColor()
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
        let rect = self.collectionView!.bounds
        let screenWidth = rect.size.width
        var width = round(screenWidth / 7.0)
        let height = width * 0.8
        
        let isLastCellInRow = (indexPath.item % 7 == 0)
        if isLastCellInRow {
            let remainderWidth = screenWidth - (width * 7)
            width += remainderWidth
        }
        return CGSize(width: width, height: height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0); //top,left,bottom,right
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            let headerLblTitle = header.viewWithTag(101) as! UILabel
            
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            
            headerLblTitle.text = firstDayOfMonth.monthNameFull()
            headerLblTitle.textColor = monthTitleColor
            header.backgroundColor = UIColor.white
            return header;
        }
        return UICollectionReusableView()
    }

    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EPCalendarCell1
        if cell.isCellSelectable! {
            self.selectionDate.addDate(cell.currentDate)
            if let sectionBoundForVisibleItems = self.collectionView?.sectionBoundForVisibleItems(),
                let lowerBound = sectionBoundForVisibleItems.lowerBound,
                let upperBound = sectionBoundForVisibleItems.upperBound {
                
                let needToUpdateSections = IndexSet(lowerBound ... upperBound)
                self.collectionView?.reloadSections(needToUpdateSections)
            }
        }
    }
    
    //MARK: Button Actions
    
    internal func onTouchCancelButton() {
       //TODO: Create a cancel delegate
        calendarDelegate?.epCalendarPicker(self, didCancel: NSError(domain: "EPCalendarPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
        
    }
    
    internal func onTouchDoneButton() {
        //gathers all the selected dates and pass it to the delegate
        calendarDelegate?.epCalendarPicker(self, didSelectDate: self.selectionDate.rangeDate)
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
