//
//  CalendarViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


final class CalendarViewController: BaseViewController<CalendarView, CalendarViewModel> {
    
    let gregorianCalendar = Calendar(identifier: .gregorian)
    // 선택된 날짜를 저장하는 속성 추가
    var selectedDate: DateComponents? = nil
    
    var locations: [BowlingLocation] = []
    
    private var eventDates: Set<DateComponents> = [] // ✅ 이벤트가 있는 날짜 저장
    
    
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
    
  
    
    
    override func bind() {
        
        
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
        
        

        mainView.updateTableViewHeight()
        
        //mainView.layoutIfNeeded()
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
    
    // MARK: - 선택할 수 있는 날짜
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
        
        let hasEvent = eventDates.first { eventDate in
            return eventDate.year == dateComponents.year &&
            eventDate.month == dateComponents.month &&
            eventDate.day == dateComponents.day
        } != nil
        
        if hasEvent {
            print("✅ 이벤트 있음: \(dateComponents)")
            return UICalendarView.Decoration.customView {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
                view.backgroundColor = .red
                view.layer.cornerRadius = 3
                return view
            }
        } else {
            print("❌ 이벤트 없음: \(dateComponents)")
        }
        
        
        return nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        guard let newMonth = calendarView.visibleDateComponents.month,
              let newYear = calendarView.visibleDateComponents.year else { return }
        
        print("🗓️ 새로운 월로 변경됨: \(newYear)-\(newMonth)")
        
        // ✅ 변경된 월의 데이터를 다시 불러옴
        loadEventDates(for: newYear, month: newMonth)
    }
    
    func loadEventDates(for year: Int, month: Int) {
        // ✅ 테이블뷰의 데이터에서 해당 월의 이벤트만 필터링 (예제 데이터)
        let sampleEventDates = ["2025-04-03", "2025-04-10", "2025-04-15", "2025-05-02"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        eventDates = Set(sampleEventDates.compactMap { dateString in
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            return (components.year == year && components.month == month) ? components : nil
        })
        
        
        
        if #available(iOS 17.0, *) {
            print("🔴 이벤트 날짜: \(eventDates)")
            mainView.calendarView.reloadDecorations(forDateComponents: Array(eventDates), animated: true)
        } else {
            
            if let mainView = self.view as? CalendarView {
                let oldCalendarView = mainView.calendarView
                let newCalendarView = UICalendarView() // 새로운 캘린더 뷰 생성
                
                // 기존 캘린더의 설정 유지 (필요한 속성 복사)
                newCalendarView.frame = oldCalendarView.frame
                newCalendarView.delegate = self
                
                // 기존 캘린더 제거 후 새 캘린더 추가
                oldCalendarView.removeFromSuperview()
                mainView.addSubview(newCalendarView)
                
                mainView.calendarView = newCalendarView
            }
            
        }
        
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
