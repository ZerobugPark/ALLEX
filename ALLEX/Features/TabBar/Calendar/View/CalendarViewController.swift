//
//  CalendarViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit



class CalendarViewController: BaseViewController<CalendarView, CalendarViewModel> {
    
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    // 선택된 날짜를 저장하는 속성 추가
    var selectedDate: DateComponents? = nil
    
    var locations: [BowlingLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 캘린더 설정
        let selection = UICalendarSelectionSingleDate(delegate: self)
        mainView.calendarView.selectionBehavior = selection
        mainView.calendarView.delegate = self
        
        // 테이블뷰 설정
        mainView.tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.id)
        
        configureInitialDate()
        restrictDateRange()
        
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func setupData() {
           // Example data similar to your screenshot
           locations = [
               BowlingLocation(
                   name: "더클라임 서울대점",
                   time: "1h 0m",
                   games: [
                       BowlingGame(name: "검정", score: "2완등", frames: "2무제", percentage: 100),
                       BowlingGame(name: "갈색", score: "2완등", frames: "2무제", percentage: 100)
                   ]
               ),
               BowlingLocation(
                   name: "더클라임 B 홍대점",
                   time: "1h 1m",
                   games: [
                       BowlingGame(name: "9", score: "0완등", frames: "2무제", percentage: 0),
                       BowlingGame(name: "8", score: "0완등", frames: "2무제", percentage: 0)
                   ]
               )
           ]
           
        mainView.tableView.reloadData()
       }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.id, for: indexPath) as! ResultTableViewCell
        cell.configure(with: locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Dynamic height based on number of games
        return CGFloat(120 + (locations[indexPath.row].games.count * 30))
    }

}


extension CalendarViewController {
    
    private func configureInitialDate() {
        let today = Date()
        let components = Calendar.current.dateComponents([.year, .month], from: today)
        mainView.calendarView.visibleDateComponents = DateComponents(
            calendar: Calendar.current,
            year: components.year,
            month: components.month,
            day: 1
        )
    }
    
    private func restrictDateRange() {
        let fromDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let toDateComponents = DateComponents(year: 2101, month: 1, day: 1)
        
        guard let fromDate = Calendar.current.date(from: fromDateComponents),
              let toDate = Calendar.current.date(from: toDateComponents) else {
            fatalError("Invalid date components")
        }
        
        mainView.calendarView.availableDateRange = DateInterval(start: fromDate, end: toDate)
    }
    
}


extension CalendarViewController: UICalendarViewDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        guard let dateComponents = dateComponents,
              let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else {
            return false
        }
        
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        let todayYear = todayComponents.year!
        let todayMonth = todayComponents.month!
        let todayDay = todayComponents.day!
        
        if year < todayYear {
            return true
        } else if year == todayYear {
            if month < todayMonth {
                return true
            } else if month == todayMonth {
                return day <= todayDay
            }
        }
        return false
    }
    

    
    
    // UICalendarViewDelegate
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        if dateComponents.year == todayComponents.year,
           dateComponents.month == todayComponents.month,
           dateComponents.day == todayComponents.day {
            return UICalendarView.Decoration.customView {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
                view.backgroundColor = .blue // "오늘"에 파란색 점 추가
                view.layer.cornerRadius = 2.5
                return view
            }
        }
        return nil
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    // UICalendarSelectionSingleDateDelegate
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents
        if let dateComponents = dateComponents {
            mainView.calendarView.reloadDecorations(forDateComponents: [dateComponents], animated: true)
        }
        // 선택된 날짜 처리
        if let date = Calendar.current.date(from: dateComponents ?? DateComponents()) {
            print("Selected date: \(date)")
        }
    }
}
