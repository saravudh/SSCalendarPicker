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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 1, day : 2)
        let selectionDate = SSSelectionDate(selectionType: .single, selectedDates: nil)
        
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date1)
        XCTAssertTrue(selectionDate.hasData())
        
        XCTAssertEqual(date1, selectionDate.singleDate)
        XCTAssertEqual(0, selectionDate.multipleDates.count)
        XCTAssertNil(selectionDate.rangeDate)
        
        selectionDate.removeDate(date2)
        XCTAssertEqual(date1, selectionDate.singleDate)

        selectionDate.removeDate(date1)
        XCTAssertFalse(selectionDate.hasData())
        
        selectionDate.addDate(date2)
        XCTAssertEqual(date2, selectionDate.singleDate)
    }
    
    func testMultipleData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date21 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 3)
        let dateXX = Date(year : 2017, month : 11, day : 5)
        
        // add
        let selectionDate = SSSelectionDate(selectionType: .multiple, selectedDates: nil)
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date1)
        XCTAssertTrue(selectionDate.hasData())
        XCTAssertEqual(1, selectionDate.multipleDates.count)
        XCTAssertTrue(selectionDate.multipleDates.contains(date1))
        
        selectionDate.addDate(date2)
        XCTAssertEqual(2, selectionDate.multipleDates.count)
        XCTAssertTrue(selectionDate.multipleDates.contains(date1))
        XCTAssertTrue(selectionDate.multipleDates.contains(date2))

        selectionDate.addDate(date3)
        XCTAssertEqual(3, selectionDate.multipleDates.count)
        XCTAssertTrue(selectionDate.multipleDates.contains(date1))
        XCTAssertTrue(selectionDate.multipleDates.contains(date2))
        XCTAssertTrue(selectionDate.multipleDates.contains(date3))

        selectionDate.addDate(date21)
        XCTAssertEqual(3, selectionDate.multipleDates.count)
        XCTAssertTrue(selectionDate.multipleDates.contains(date1))
        XCTAssertTrue(selectionDate.multipleDates.contains(date2))
        XCTAssertTrue(selectionDate.multipleDates.contains(date21))
        XCTAssertTrue(selectionDate.multipleDates.contains(date3))
        
        // remove
        selectionDate.removeDate(dateXX)
        XCTAssertEqual(3, selectionDate.multipleDates.count)
        
        selectionDate.removeDate(date1)
        XCTAssertEqual(2, selectionDate.multipleDates.count)
        XCTAssertFalse(selectionDate.multipleDates.contains(date1))
        XCTAssertTrue(selectionDate.multipleDates.contains(date2))
        XCTAssertTrue(selectionDate.multipleDates.contains(date21))
        XCTAssertTrue(selectionDate.multipleDates.contains(date3))

        selectionDate.removeDate(date2)
        XCTAssertEqual(1, selectionDate.multipleDates.count)
        XCTAssertTrue(selectionDate.multipleDates.contains(date3))

        selectionDate.removeDate(date3)
        XCTAssertEqual(0, selectionDate.multipleDates.count)
    }
    
    func testRangeDataNormalData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)

        // [1] create SSSelectionDate object -> anil
        let selectionDate = SSSelectionDate(selectionType: .range, selectedDates: nil)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)

        // [2] add date1 -> (begin:date1, end:nil)
        selectionDate.addDate(date1)
        XCTAssertTrue(selectionDate.hasData())
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate2.begin)
        XCTAssertNil(rangeDate2.end)

        // [3] add date2 -> (begin:date1, end:date2)
        selectionDate.addDate(date2)
        let rangeDate3 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate3.begin)
        XCTAssertEqual(date2, rangeDate3.end)
        
        // [4] remove date2 -> (begin:date1, end:nil)
        selectionDate.removeDate(date2)
        let rangeDate4 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate4.begin)
        XCTAssertNil(rangeDate4.end)

        // [5] add date2 -> (begin:date1, end:date2)
        selectionDate.addDate(date2)
        let rangeDate5 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate5.begin)
        XCTAssertEqual(date2, rangeDate5.end)
        
        // [6] remove date1 -> nil
        selectionDate.removeDate(date1)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)
    }
    
    func testRangeDataAddDataWhenAlreadyHasData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 1)
        
        // [1] add date2 then date1
        let selectionDate = SSSelectionDate(selectionType: .range, selectedDates: nil)
        selectionDate.addDate(date1)
        selectionDate.addDate(date2)
        let rangeDate1 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate1.begin)
        XCTAssertEqual(date2, rangeDate1.end)
        
        // [3] add date2 and date3 then date1
        selectionDate.removeAll()
        XCTAssertFalse(selectionDate.hasData())
        selectionDate.addDate(date2)
        selectionDate.addDate(date3)
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date2, rangeDate2.begin)
        XCTAssertEqual(date3, rangeDate2.end)
        selectionDate.addDate(date1)
        let rangeDate21 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate21.begin)
        XCTAssertEqual(date3, rangeDate21.end)

        // [4] add date1 date3 then date 2
        selectionDate.removeAll()
        selectionDate.addDate(date1)
        selectionDate.addDate(date3)
        let rangeDate3 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate3.begin)
        XCTAssertEqual(date3, rangeDate3.end)
        selectionDate.addDate(date2)
        let rangeDate31 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate31.begin)
        XCTAssertEqual(date2, rangeDate31.end)
    }
    
    func testRangeRemoveData() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 1)
        
        // [1] add date1 and date2 then remove date2
        let selectionDate1 = SSSelectionDate(selectionType: .range, selectedDates: nil)
        selectionDate1.addDate(date1)
        selectionDate1.addDate(date2)
        selectionDate1.removeDate(date2)
        let rangeDate1 = selectionDate1.rangeDate!
        XCTAssertEqual(date1, rangeDate1.begin)
        XCTAssertNil(rangeDate1.end)
        
        // [2] add date1 and date2 then remove date1
        let selectionDate2 = SSSelectionDate(selectionType: .range, selectedDates: nil)
        selectionDate2.addDate(date1)
        selectionDate2.addDate(date2)
        selectionDate2.removeDate(date1)
        XCTAssertFalse(selectionDate2.hasData())
        
        // [3] add date1 and date2 then remove date3
        let selectionDate3 = SSSelectionDate(selectionType: .range, selectedDates: nil)
        selectionDate3.addDate(date1)
        selectionDate3.addDate(date2)
        selectionDate3.removeDate(date3)
        let rangeDate3 = selectionDate3.rangeDate!
        XCTAssertEqual(date1, rangeDate3.begin)
        XCTAssertEqual(date2, rangeDate3.end)
    }
    
    func testRangeDataEnd_LT_Begin() {
        let date1 = Date(year : 2017, month : 1, day : 1)
        let date2 = Date(year : 2017, month : 2, day : 1)
        let date3 = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(selectionType: .range, selectedDates: nil)
        
        selectionDate.addDate(date2)
        selectionDate.addDate(date1)
        let rangeDate1 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate1.begin)
        XCTAssertNil(rangeDate1.end)
        
        selectionDate.addDate(date3)
        let rangeDate2 = selectionDate.rangeDate!
        XCTAssertEqual(date1, rangeDate2.begin)
        XCTAssertEqual(date3, rangeDate2.end)
    }

    
    func testSingleDataAddOutOfBoundData() {
        let minDate = Date(year : 2017, month : 1, day : 1)
        let maxDate = Date(year : 2017, month : 2, day : 1)
        let date = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(selectionType: .single, selectedDates: nil, minDate: minDate, maxDate: maxDate)
        selectionDate.addDate(date)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.singleDate)
    }
    
    func testMultipleAddOutOfBoundData() {
        let minDate = Date(year : 2017, month : 1, day : 1)
        let maxDate = Date(year : 2017, month : 2, day : 1)
        let date = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(selectionType: .multiple, selectedDates: nil, minDate: minDate, maxDate: maxDate)
        selectionDate.addDate(date)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertEqual(0, selectionDate.multipleDates.count)
    }
    
    func testRangeDataAddOutOfBoundData() {
        let minDate = Date(year : 2017, month : 1, day : 1)
        let maxDate = Date(year : 2017, month : 2, day : 1)
        let date = Date(year : 2017, month : 3, day : 3)
        let selectionDate = SSSelectionDate(selectionType: .range, selectedDates: nil, minDate: minDate, maxDate: maxDate)
        selectionDate.addDate(date)
        XCTAssertFalse(selectionDate.hasData())
        XCTAssertNil(selectionDate.rangeDate)
    }
    
}
