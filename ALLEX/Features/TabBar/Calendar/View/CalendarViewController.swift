//
//  CalendarViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import FirebaseAnalytics
import RxCocoa
import RxSwift




final class CalendarViewController: BaseViewController<CalendarView, CalendarViewModel> {
    
    let gregorianCalendar = Calendar(identifier: .gregorian)
    // 선택된 날짜를 저장하는 속성 추가
    var selectedDate: DateComponents? = nil
    
    var coordinator: CalendarCoordinator?

    
    private var eventDates: Set<DateComponents> = [] //  이벤트가 있는 날짜 저장
    
    private let currentDate = PublishRelay<Date>()
    private let changedMonth = PublishRelay<(Int,Int)>()
    
    private let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
    
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
      
      
        navigationItem.rightBarButtonItem = rightBarButton
      
   
    }
    

    
    override func bind() {
        
        
        let input = CalendarViewModel.Input(viewDidLoad: Observable.just(()), changedMonth: changedMonth, currentDate: currentDate)
        let output = viewModel.transform(input: input)
        
        output.setupList.drive(mainView.tableView.rx.items(cellIdentifier: ResultTableViewCell.id, cellType: ResultTableViewCell.self)) { row, element, cell in
            
            cell.configure(with: element)
            
        }.disposed(by: disposeBag)
        
        output.setupList.drive(with: self) { owner, _ in
            owner.mainView.updateTableViewHeight()
        }.disposed(by: disposeBag)
        
        output.eventList.drive(with: self) { owner, data in
            owner.loadEventDates(for: data.newYear, month: data.newMonth, eventData: data.list)
        }.disposed(by: disposeBag)
        
        
        mainView.tableView.rx.modelSelected(ClimbingInfo.self).bind(with: self) { owner, value in

            let data = ClimbingRecordQuery(objectId: value.id, date: value.climbDate)
        
            owner.coordinator?.showDetail(mode: .detail(data))
            
        }.disposed(by: disposeBag)
        
        rightBarButton.rx.tap.bind(with: self) { owner, _ in
            
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "manualRecordButton",
                AnalyticsParameterItemName: "Manual Record Button",
                AnalyticsParameterContentType: "button"
            ])

            
            owner.coordinator?.showModify(mode: .add)
            
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
        
    deinit {
        coordinator = nil
        print("\(description) Deinit")
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
            //print(" 이벤트 있음: \(dateComponents)")
            return UICalendarView.Decoration.customView {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
                view.backgroundColor = .red
                view.layer.cornerRadius = 3
                return view
            }
        } else {
            //print(" 이벤트 없음: \(dateComponents)")
        }
        
        
        return nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        guard let newMonth = calendarView.visibleDateComponents.month,
              let newYear = calendarView.visibleDateComponents.year else { return }
        
        // 변경된 월의 데이터를 다시 불러옴
        changedMonth.accept((newYear,newMonth))
     
    }
    
    func loadEventDates(for year: Int, month: Int, eventData: [String]) {
        // 테이블뷰의 데이터에서 해당 월의 이벤트만 필터링 (예제 데이터)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        eventDates = Set(eventData.compactMap { dateString in
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            return (components.year == year && components.month == month) ? components : nil
        })
        
        
        
        if #available(iOS 17.0, *) {
            //print(" 이벤트 날짜: \(eventDates)")
            mainView.calendarView.reloadDecorations(forDateComponents: Array(eventDates), animated: true)
        } else {
            
            if let mainView = self.view as? CalendarView {
                let oldCalendarView = mainView.calendarView
                let newCalendarView = UICalendarView() // 새로운 캘린더 뷰 생성
                
                // 기존 캘린더의 설정 유지 (필요한 속성 복사)
                newCalendarView.frame = oldCalendarView.frame
                weak var weakSelf = self
                newCalendarView.delegate = weakSelf
                
                // 기존 캘린더 제거 후 새 캘린더 추가
                oldCalendarView.delegate = nil
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
        
        //print("현재 TimeZone: \(TimeZone.current.identifier)")
        
        // DateComponents에 시간대 정보 추가
        if var fullDateComponents = dateComponents {
            fullDateComponents.timeZone = TimeZone.current
            fullDateComponents.hour = 12  // 정오로 설정하여 날짜 변경 방지
            
            if let date = Calendar.current.date(from: fullDateComponents) {
                currentDate.accept(date)
            }
        }
    }
}
