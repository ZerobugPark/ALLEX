//
//  DateTextField.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DateTextField: UITextField, UITextFieldDelegate {

    private let datePicker = UIDatePicker()
    private var datePickerContainer = UIView()
    private let toolbarContainer = UIView()

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

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .setAllexColor(.textTertiary)
        datePicker.backgroundColor = .setAllexColor(.backGroundSecondary)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        let today = Date()
        datePicker.maximumDate = today

        datePickerContainer.layer.cornerRadius = 10
        datePickerContainer.clipsToBounds = true
        datePickerContainer.translatesAutoresizingMaskIntoConstraints = false

        // 커스텀 툴바 설정
        toolbarContainer.backgroundColor = .setAllexColor(.toolBar)
        toolbarContainer.translatesAutoresizingMaskIntoConstraints = false

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = .setAllexColor(.textTertiary)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.tintColor = .setAllexColor(.textTertiary)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        toolbarContainer.addSubview(cancelButton)
        toolbarContainer.addSubview(doneButton)
        datePickerContainer.addSubview(datePicker)
        datePickerContainer.addSubview(toolbarContainer)

        // SnapKit으로 제약 조건 설정
        datePicker.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolbarContainer.snp.top)
        }

        toolbarContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(16) // Cancel 버튼 오른쪽에 16pt 간격
            make.centerY.equalToSuperview()
        }
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()

        if let parentView = self.superview {
            parentView.addSubview(datePickerContainer)
            
            datePickerContainer.snp.makeConstraints { make in
                make.center.equalTo(parentView)
                make.width.equalTo(parentView).multipliedBy(0.8)
                make.height.equalTo(400)
            }
        }
        
        return false
    }

    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.text = dateFormatter.string(from: datePicker.date)
        self.sendActions(for: .valueChanged)
        self.resignFirstResponder()
    }

    @objc private func cancelPressed() {
        self.resignFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        datePickerContainer.removeFromSuperview()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editingBeginSubject.accept(())
        return false
    }
}
