//
//  CalendarView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import SnapKit

final class CalendarView: BaseView {
    
    var calendarView = UICalendarView()
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let tableView = UITableView()
    
    let recordButton = BaseButton(key: .start)
    
    private let gregorianCalendar = Calendar(identifier: .gregorian)
    
    private var tableViewHeightConstraint: Constraint?
    private var containerViewHeightConstraint: Constraint?
    
    override func configureHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(calendarView, tableView)
        self.addSubview(recordButton)
    }
    
    override func configureLayout() {
    
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(tableView.snp.bottom).offset(16)
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top).offset(-24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            self.tableViewHeightConstraint = make.height.equalTo(1).constraint // 초기 높이 설정
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // ✅ 레이아웃이 확정된 후 높이 업데이트
        updateTableViewHeight()
    }
    
    
    func updateTableViewHeight() {
        
        self.layoutIfNeeded()
                
        // ✅ layoutSubviews()에서 호출되므로 정확한 높이를 가져올 수 있음
        let calendarHeight: CGFloat = calendarView.frame.height
        let tableHeight: CGFloat = tableView.contentSize.height //max(CGFloat(rowCount) * 240.0, 1)//CGFloat(rowCount) * tableView.rowHeight
                
        let totalHeight: CGFloat = calendarHeight + tableHeight + 40.0
        
        print("📏  tableView.rowHeight ",  tableView.contentSize.height)
        print("📏 TableView Height:", tableHeight)
        print("📏 CalendarView Height:", calendarHeight) // 🔥 디버깅용
        print("📏 Total Container Height:", totalHeight)

        tableViewHeightConstraint?.update(offset: tableHeight)
        
        containerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(recordButton.snp.bottom).offset(16)
        }

        scrollView.contentSize = CGSize(width: self.frame.width, height: totalHeight) // ✅ 올바른 크기 지정
        
    }
    
}



