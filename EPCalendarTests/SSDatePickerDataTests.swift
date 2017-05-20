//
//  SSRangeDataTests.swift
//  EPCalendar
//
//  Created by Saravudh Sinsomros on 4/16/2560 BE.
//  Copyright © 2560 Saravudh Sinsomros. All rights reserved.
//

import XCTest
@testable import EPCalendar

class SSDatePickerDataTests: XCTestCase {
    let minDate = Date(year: 2000, month: 1, day: 1)
    let maxDate = Date(year: 2020, month: 1, day: 1)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRangeDataNormalData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)

        // [1] create SSSelectionDate object -> anil
        let selectionDate = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)

        // [2] add date1 -> (begin:date1, end:nil)
        selectionDate.addDate(date1)
        XCTAssertTrue(selectionDate.hasData())
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate2.departDate)
        XCTAssertNil(rangeDate2.returnDate)

        // [3] add date2 -> (begin:date1, end:date2)
        selectionDate.addDate(date2)
        let rangeDate3 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate3.departDate)
        XCTAssertEqual(date2, rangeDate3.returnDate)
        
        // [4] remove date2 -> (begin:date1, end:nil)
        selectionDate.removeDate(date2)
        let rangeDate4 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate4.departDate)
        XCTAssertNil(rangeDate4.returnDate)

        // [5] add date2 -> (begin:date1, end:date2)
        selectionDate.addDate(date2)
        let rangeDate5 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate5.departDate)
        XCTAssertEqual(date2, rangeDate5.returnDate)
        
        // [6] remove date1 -> nil
        selectionDate.removeDate(date1)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)
    }
    
    func testRangeDataAddDataWhenAlreadyHasData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 1)
        let date4 = Date(year : 2017, month : 3, day : 10)
        
        // [1] add date2 then date1
        let selectionDate = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        selectionDate.addDate(date2)
        selectionDate.addDate(date1)
        let rangeDate1 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate1.departDate)
        XCTAssertNil(rangeDate1.returnDate)
        
        // [2] add date1 and date2 then date1
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date1)
        selectionDate.addDate(date2)
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate2.departDate)
        XCTAssertEqual(date2, rangeDate2.returnDate)
        selectionDate.addDate(date1)
        let rangeDate21 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate21.departDate)
        XCTAssertNil(rangeDate21.returnDate)

        // [3] add date1 and date2 then date2
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date1)
        selectionDate.addDate(date2)
        let rangeDate3 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate3.departDate)
        XCTAssertEqual(date2, rangeDate3.returnDate)
        selectionDate.addDate(date2)
        let rangeDate31 = selectionDate.rangeDate!
        XCTAssertEqual(date2, rangeDate31.departDate)
        XCTAssertNil(rangeDate31.returnDate)
        
        
        // [4] add date2 and date3 then date1
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date2)
        selectionDate.addDate(date3)
        let rangeDate4 = selectionDate.rangeDate!
        XCTAssertEqual(date2, rangeDate4.departDate)
        XCTAssertEqual(date3, rangeDate4.returnDate)
        selectionDate.addDate(date1)
        let rangeDate41 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate41.departDate)
        XCTAssertNil(rangeDate41.returnDate)
        
        
        // [5] add date2 and date3 then date4
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date2)
        selectionDate.addDate(date3)
        let rangeDate5 = selectionDate.rangeDate!
        XCTAssertEqual(date2, rangeDate5.departDate)
        XCTAssertEqual(date3, rangeDate5.returnDate)
        selectionDate.addDate(date4)
        let rangeDate51 = selectionDate.rangeDate!
        XCTAssertEqual(date4, rangeDate51.departDate)
        XCTAssertNil(rangeDate41.returnDate)
        
        // [6] add date1 and date4 then date2
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date1)
        selectionDate.addDate(date4)
        let rangeDate6 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate6.departDate)
        XCTAssertEqual(date4, rangeDate6.returnDate)
        selectionDate.addDate(date2)
        let rangeDate61 = selectionDate.rangeDate!
        XCTAssertEqual(date2, rangeDate61.departDate)
        XCTAssertNil(rangeDate61.returnDate)
        
    }
    
    func testRangeRemoveData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 1)
        
        // [1] add date1 and date2 then remove date2
        let selectionDate1 = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        selectionDate1.addDate(date1)
        selectionDate1.addDate(date2)
        selectionDate1.removeDate(date2)
        let rangeDate1 = selectionDate1.rangeDate!
        XCTAssertEqual(date1, rangeDate1.departDate)
        XCTAssertNil(rangeDate1.returnDate)
        
        // [2] add date1 and date2 then remove date1
        let selectionDate2 = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        selectionDate2.addDate(date1)
        selectionDate2.addDate(date2)
        selectionDate2.removeDate(date1)
        XCTAssertFalse(selectionDate2.hasData())
        
        // [3] add date1 and date2 then remove date3
        let selectionDate3 = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        selectionDate3.addDate(date1)
        selectionDate3.addDate(date2)
        selectionDate3.removeDate(date3)
        let rangeDate3 = selectionDate3.rangeDate!
        XCTAssertEqual(date1, rangeDate3.departDate)
        XCTAssertEqual(date2, rangeDate3.returnDate)
    }
    
    func testRangeDataEnd_LT_Begin() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(minDate: self.minDate, maxDate: self.maxDate)
        
        selectionDate.addDate(date2)
        selectionDate.addDate(date1)
        let rangeDate1 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate1.departDate)
        XCTAssertNil(rangeDate1.returnDate)
        
        selectionDate.addDate(date3)
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate2.departDate)
        XCTAssertEqual(date3, rangeDate2.returnDate)
    }

    func testRangeDataAddOutOfBoundData() {
        let minDate = Date(year : 2017, month : 1, day : 1)
        let maxDate = Date(year : 2017, month : 2, day : 1)
        let date = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(minDate: minDate, maxDate: maxDate)
        selectionDate.addDate(date)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)
    }
    
    func testIsSelectedDateRange() {
        let minDate = Date(year : 2000, month : 1, day : 1)
        let maxDate = Date(year : 2100, month : 12, day : 31)
        let date1 = Date(year : 2017, month : 2, day : 1)
        let date2 = Date(year : 2017, month : 3, day : 1)
        
        let expectedStart = Date(year : 2017, month : 2, day : 1)
        let expectedBetween = Date(year : 2017, month : 2, day : 22)
        let expectedEnd = Date(year : 2017, month : 3, day : 1)
        let unexpected1 = Date(year : 2017, month : 1, day : 31)
        let unexpected2 = Date(year : 2017, month : 4, day : 1)
        
        let selectionDate = SSSelectionDate(minDate: minDate, maxDate: maxDate)
        selectionDate.addDate(date1)
        selectionDate.addDate(date2)
        
        XCTAssertEqual(SSSelectedType.beginOrSelected, selectionDate.isSelectedDate(date: expectedStart))
        XCTAssertEqual(SSSelectedType.between, selectionDate.isSelectedDate(date: expectedBetween))
        XCTAssertEqual(SSSelectedType.end, selectionDate.isSelectedDate(date: expectedEnd))
        XCTAssertEqual(SSSelectedType.unselected, selectionDate.isSelectedDate(date: unexpected1))
        XCTAssertEqual(SSSelectedType.unselected, selectionDate.isSelectedDate(date: unexpected2))
    }
}
