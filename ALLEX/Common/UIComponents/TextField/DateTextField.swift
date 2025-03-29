//
//  DateTextField.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

import RxCocoa
import RxSwift

final class DateTextField: UITextField, UITextFieldDelegate {

    private let datePicker = UIDatePicker()
    private var datePickerContainer = UIView()

    let editingBeginSubject = PublishRelay<Void>()
     
    init() {
        super.init(frame: .zero)
   
        self.delegate = self
        setupPaddingTextField()
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DatePicker 설정
    private func setupDatePicker() {

        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .setAllexColor(.textTertiary)
        datePicker.backgroundColor = .setAllexColor(.backGroundSecondary)
        
    
        let today = Date()
        datePicker.maximumDate = today
        
        // 컨테이너 설정
        datePickerContainer.layer.cornerRadius = 10
        datePickerContainer.clipsToBounds = true
       
        // 버튼 액션 설정
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        
        // 툴바 설정
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, doneButton], animated: false)

        
        let appearance = UIToolbarAppearance()
        appearance.backgroundColor = .setAllexColor(.toolBar)
        toolbar.standardAppearance = appearance
        toolbar.scrollEdgeAppearance = appearance
   
        toolbar.tintColor = .setAllexColor(.textTertiary) // 툴바 버튼 색
        // MARK: - Layout
        datePickerContainer.addSubviews(datePicker, toolbar)
       
        
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(toolbar.snp.top)
        }

        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(datePickerContainer.snp.bottom)
        }
        

    }

    // MARK: - becomeFirstResponder
    override func becomeFirstResponder() -> Bool {
    
        super.becomeFirstResponder()

        // 커스텀 DatePicker를 화면에 표시
        if let parentView = self.superview {
            // DatePicker가 부모 뷰에 추가되지 않았다면 추가
            parentView.addSubview(datePickerContainer)
            
            datePickerContainer.snp.makeConstraints { make in
                make.center.equalTo(parentView)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalToSuperview().multipliedBy(0.6)
            }
            
        }
        
        return false // 키보드가 올라오는 걸 방지하기
    }

    // MARK: - Done & Cancel 버튼 액션
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.text = dateFormatter.string(from: datePicker.date)
        
        // 텍스트에 직접 대입하는것은 RxSwift에서 조회가 불가능
        // 값이 변경되었다는것을 알려줘서 RxSWift가 알 수 있게 처리해야 함
        self.sendActions(for: .valueChanged)
        
        
        self.resignFirstResponder() // 닫기
    }

    @objc private func cancelPressed() {
        
        self.resignFirstResponder() // 취소 시 닫기
    }

    // MARK: - resignFirstResponder
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        datePickerContainer.removeFromSuperview()
        return true
    }

    // MARK: - UITextFieldDelegate 메서드
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        editingBeginSubject.accept(())
        
        // 기본 키보드가 올라오는 것을 막기 위해 return false
        return false
    }
}
