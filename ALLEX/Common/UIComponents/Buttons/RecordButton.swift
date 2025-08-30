//
//  RecordButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//


import UIKit

import SnapKit

final class RecordButton: UIButton {
    
    private let recordView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 35
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    let recordButton: UIButton = {
        let button = UIButton(type: .system) // UIButton으로 변경
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 0
        return button
    }()
    
    let recordingButton: UIButton = {
        let button = UIButton(type: .system) // UIButton으로 변경
        button.backgroundColor = .red
        button.layer.borderWidth = 0
        button.isHidden = true
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        
        // customImageView 설정
        addSubviews(recordView)
        recordView.addSubviews(recordButton, recordingButton)
        
        recordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(70)
        }
        
        recordButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        
        recordingButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
       
      
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

