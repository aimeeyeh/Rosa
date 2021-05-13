//
//  CalenderViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import KDCalendar

class CalenderViewController: UIViewController {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var noRecordLabel: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()

        calendarView.dataSource = self
        calendarView.delegate = self

        setUpCalender()
        self.navigationController?.isNavigationBarHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
    }

    func setUpCalender() {

        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false

        let style = CalendarView.Style()

        style.cellShape = .bevel(8.0)
        style.cellColorDefault = UIColor.clear
        style.cellColorToday = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        style.cellSelectedBorderColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        style.cellTextColorToday = UIColor.white
        style.cellSelectedTextColor = .darkGray
        style.cellShape = CalendarView.Style.CellShapeOptions.round
        style.headerTextColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        style.weekdaysTextColor = UIColor.orange
        calendarView.marksWeekends = false

        calendarView.style = style
    }

}

extension CalenderViewController: CalendarViewDataSource, CalendarViewDelegate {

    func startDate() -> Date {

        var dateComponents = DateComponents()
        dateComponents.month = -3
        let today = Date()
        guard let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today) else {
            return today
        }
        return threeMonthsAgo

    }

    func endDate() -> Date {

        var dateComponents = DateComponents()
        dateComponents.month = 3
        let today = Date()
        guard let threeMonthsAfter = self.calendarView.calendar.date(byAdding: dateComponents, to: today) else {
            return today
        }
        return threeMonthsAfter

    }

    func headerString(_ date: Date) -> String? {
        return nil
    }

    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        return
    }

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {

        noRecordLabel.isHidden = false

    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {

        noRecordLabel.isHidden = true

    }

    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        return
    }
}
