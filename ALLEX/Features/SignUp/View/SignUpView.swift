//
//  SignUpView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

import SnapKit

final class SignUpView: BaseView {

    let profile = ProfileSettingView()
    
    override func configureHierarchy() {
        self.addSubview(profile)
        
    }
    
    override func configureLayout() {
        
        profile.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        

}
