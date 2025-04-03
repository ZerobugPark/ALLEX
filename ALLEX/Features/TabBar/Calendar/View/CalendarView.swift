//
//  CalendarView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import SnapKit

final class CalendarView: BaseView {

    let calendarView = UICalendarView()
    
    let scrollView = UIScrollView()
    let containerView = UIView()

    let tableView = UITableView()
    

    private let gregorianCalendar = Calendar(identifier: .gregorian)

    
    override func configureHierarchy() {
        self.addSubview(scrollView)
           scrollView.addSubview(containerView)
           containerView.addSubviews(calendarView, tableView)
        
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            // 컨테이너 높이는 내부 콘텐츠에 맞춰 자동으로 조정됨
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            // 테이블 뷰 높이 설정 - 스크린샷에 맞게 적절한 높이 설정
            make.height.greaterThanOrEqualTo(300)
        }
      
        
    }
    
    override func configureView() {
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // 캘린더 설정
        calendarView.calendar = gregorianCalendar
        calendarView.fontDesign = .rounded
        calendarView.tintColor = .setAllexColor(.textTertiary)
        
    
    //    tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.isScrollEnabled = false // 스크롤뷰 내에서는 테이블뷰 스크롤 비활성화
     
        
    }
}

