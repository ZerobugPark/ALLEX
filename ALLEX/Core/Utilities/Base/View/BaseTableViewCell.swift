//
//  BaseTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .setAllexColor(.backGround)
        self.selectionStyle = .none
        
        configureHierarchy()
        configureLayout()
        configureView()
       
     
    }


    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }

    
    deinit {
        print("\(description) Deinit")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
