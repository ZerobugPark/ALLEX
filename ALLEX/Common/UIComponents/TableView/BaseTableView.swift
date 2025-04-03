//
//  BaseTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

final class BaseTableView: UITableView {
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configuationTableView()
    }
    
    
    private func configuationTableView() {
        separatorStyle = .none
        rowHeight = 70
        bounces = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
