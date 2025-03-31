//
//  PopUpViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

class PopUpViewController: UIViewController {

    
    var coordinator: CameraCoordinator?
    
    private let viewContainer = UIView()
    private let backButton = UIButton()
    
    private let stackView = UIStackView()
    private let roundRectView1 = UIView()
    private let roundRectView2 = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        
        print(coordinator)
        
        backButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.coordinator?.dismiss()
        }.disposed(by: disposeBag)
        //backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    

    
    private func configureHierarchy() {
        // 뷰 계층 구조 설정
        view.addSubview(viewContainer)
        
        // backButton (X 버튼) 추가
        viewContainer.addSubview(backButton)
        
        // 스택뷰 설정
        viewContainer.addSubview(stackView)
        
        // 스택뷰에 둥근 사각형 뷰 추가
        stackView.addArrangedSubview(roundRectView1)
        stackView.addArrangedSubview(roundRectView2)
        
    }
    
    private func configureLayout() {
        // viewContainer (중앙 뷰) 제약 설정
        viewContainer.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.snp.width).multipliedBy(0.65)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
        // backButton (X 버튼) 제약 설정
        backButton.snp.makeConstraints { make in
            make.top.equalTo(viewContainer.snp.top).offset(16)
            make.left.equalTo(viewContainer.snp.left).offset(16)
         //   make.size.equalTo(12)
        }
        
        // stackView 제약 설정 (컨테이너 뷰의 인셋 적용)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16) // 왼쪽 인셋 16
        }
        
        // 첫 번째 둥근 사각형 뷰 (roundRectView1) 제약 설정
        roundRectView1.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width) // stackView 너비에 맞춤
            make.height.equalTo(viewContainer.snp.height).multipliedBy(0.35) // 원하는 높이 설정
        }
        
        // 두 번째 둥근 사각형 뷰 (roundRectView2) 제약 설정
        roundRectView2.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width) // stackView 너비에 맞춤
            make.height.equalTo(viewContainer.snp.height).multipliedBy(0.35)
        }
        
    }
    
    private func configureView() {
        
        // 둥근 사각형 뷰 스타일 설정
        roundRectView1.layer.cornerRadius = 20 // 둥근 사각형의 모서리 반지름
        roundRectView1.backgroundColor = .blue
        
        roundRectView2.layer.cornerRadius = 20 // 둥근 사각형의 모서리 반지름
        roundRectView2.backgroundColor = .green
        
        // 백그라운드가 컬러가 있으면, overCurrentContext기준으로 전체화면
        // clear 일 때는, addSubview한 뷰의 크기 기준
        // clear 할 때는 기본 뷰 자체가 hierarchy에 들어있지 않음
        view.backgroundColor = .black
        viewContainer.backgroundColor = .red
        
        //스토리보드의 Opacity와 같은 역할
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        // backButton 설정
        backButton.setImage(.setAllexSymbol(.xmark), for: .normal)
  
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
    }
    
    deinit {
        print(String(self.description) + " DeInit")
    }
    
  
}
