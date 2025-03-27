//
//  DateCell.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

import JTAppleCalendar
import SnapKit

// 커스텀 셀 클래스
class DateCell: JTACDayCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with cellState: CellState) {
        dateLabel.text = cellState.text
        
        // 현재 달이 아닌 날짜는 회색으로 표시
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.textColor = .black
        } else {
            dateLabel.textColor = .gray
        }
        
        // 선택된 날짜는 배경색 추가
        contentView.backgroundColor = cellState.isSelected ? .lightGray : .white
    }
}
