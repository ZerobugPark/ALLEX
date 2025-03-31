//
//  PopUpViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit



final class PopUpViewController: UIViewController {

    
    var coordinator: CameraCoordinator?
    
    private let mainView = PopUpView()
    
    override func loadView() {
        view = mainView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let writedRecordTapGesture = UITapGestureRecognizer(target: self, action: #selector(showWriteRecord))
        mainView.writeRecord.addGestureRecognizer(writedRecordTapGesture)
        
        let videoRecordTapGesture = UITapGestureRecognizer(target: self, action: #selector(showVidoRecord))
        mainView.videoRecord.addGestureRecognizer(videoRecordTapGesture)
    }
    
    
    @objc private func showWriteRecord() {
        coordinator?.showRecord()
    }
    
    @objc private func showVidoRecord() {
        coordinator?.showCamera()
    }

    
    deinit {
        print(String(self.description) + " DeInit")
    }
    
  
}
