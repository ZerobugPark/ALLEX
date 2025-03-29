//
//  SignUpViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

import JTAppleCalendar
import SnapKit


class SignUpViewController: BaseViewController<SignUpView, SignUpViewModel> {
    
    
    weak var coordinator: SignUpCoordinator?
    
    // JTAppleCalendarView 인스턴스 생성
    let calendarView: JTACMonthView = {
        let calendar = JTACMonthView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        return calendar
    }()
    
    // 날짜 포맷터
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backGround
        
      //  setupUI()
      //  configureCalendarView()
        
    }
    
  
    
}


extension SignUpViewController {
    private func setupUI() {
       // view.backgroundColor = .white
       // view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }
    }
    
    private func configureCalendarView() {
        calendarView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.scrollToDate(Date(), animateScroll: false) // 현재 날짜로 스크롤
    }
    
}

// JTACMonthView DataSource Extension
extension SignUpViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "2025 01 01") ?? Date()
        let endDate = formatter.date(from: "2025 12 31") ?? Date()
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday,
            hasStrictBoundaries: true
        )
    }
}

// JTACMonthView Delegate Extension
extension SignUpViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            return JTACDayCell()
        }
        
        print(cellState)
        cell.configure(with: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        cell.configure(with: cellState)
    }
    
    internal func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        cell.configure(with: cellState)
    }
    
    internal func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        cell.configure(with: cellState)
    }
}
