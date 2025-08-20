//
//  VideoCaptureView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit
import AVFoundation
import SnapKit

final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

final class VideoCaptureView: BaseView {
    
    
    // MARK: - UI 요소
    let previewView = CameraPreviewView()
    
    let recordButton = RecordButton()
    
    let folderButton = UIButton()
    
    private let settingsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let qualityButton = UIButton()
    
    let aspectRatioButton = UIButton()
    
    let closeButton = UIButton()
    
    
    override func configureHierarchy() {
        self.addSubviews(previewView, settingsView, containerView)
        settingsView.addSubviews(closeButton, aspectRatioButton, qualityButton)
        containerView.addSubviews(folderButton, recordButton)
        
    }
    
    override func configureLayout() {
        // MARK: - UI 설정
        
        settingsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(20)
        }
        
        
        aspectRatioButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        
        
        qualityButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(20)
        }
        
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }

        
        folderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        
    }
    
    override func configureView() {
        settingsView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        folderButton.setImage(UIImage(systemName: "folder"), for: .normal)
        folderButton.tintColor = .setAllexColor(.textSecondary)
        folderButton.isHidden = true
        
        closeButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        closeButton.tintColor = .setAllexColor(.textSecondary)
        
        qualityButton.setTitle("HD", for: .normal)
        qualityButton.setTitleColor(.setAllexColor(.textSecondary), for: .normal)
        
        previewView.isOpaque = true
        previewView.layer.masksToBounds = true
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill

        previewView.backgroundColor = .black
    }
    
    
    
}
