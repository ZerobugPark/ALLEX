//
//  PopUpViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import FirebaseAnalytics


final class PopUpViewController: UIViewController {

    
    var coordinator: CameraCoordinator?
    
    private let mainView = PopUpView()
    
    override func loadView() {
        view = mainView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let writedRecordTapGesture = UITapGestureRecognizer(target: self, action: #selector(showWriteRecord))
        mainView.writeRecord.addGestureRecognizer(writedRecordTapGesture)
        
        let videoRecordTapGesture = UITapGestureRecognizer(target: self, action: #selector(showVidoRecord))
        mainView.videoRecord.addGestureRecognizer(videoRecordTapGesture)
    }
    
    
    @objc private func showWriteRecord() {
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "recordWriteButton",
            AnalyticsParameterItemName: "Write Record Button",
            AnalyticsParameterContentType: "button"
        ])
        coordinator?.didSelectCondition(.recordWrite)
    }
    
    @objc private func showVidoRecord() {
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "recordVideoButton",
            AnalyticsParameterItemName: "Video Record Button",
            AnalyticsParameterContentType: "button"
        ])
        
        coordinator?.didSelectCondition(.recordVideo)
    }
    
    @objc private func backButtonTapped() {
        coordinator?.dismiss()
    }

    
    deinit {
        print(String(describing: self) + "Deinit")
        coordinator = nil
        
    }
  
}
