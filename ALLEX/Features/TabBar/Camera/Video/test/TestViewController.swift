//
//  TestViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 8/20/25.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {
    
    ///세션 추가
    private let session = AVCaptureSession()
    
    /// 미리보기 레이어?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissionAndSetupCamera()

    }
    
    /// 권한 확인
    private func checkPermissionAndSetupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: //권한 승인
            setupCamera()
        case .notDetermined: // 권한 요청
            /// 권한 요청은 백그라운드 스레드에서 동작
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    /// UI 설정은 메인 스레드에서 해야 하기 때문에, 메인 스레드에서 요청
                    DispatchQueue.main.async { [weak self] in
                        self?.setupCamera()
                        
                    }
                }
            }
        default:
            print("카메라 접근권한이 없음")
            
        }
        
    }
    
    private func setupCamera() {
        /// 세션 설정
        session.sessionPreset = .high // FHD
        
        /// 카메라 입력
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            /// canAdd: 이 인풋을 세션에 추가할 수 있냐?
            print("장치 오류")
            return
        }
        /// addInput 실제로 세션에 붙이는 동작
        session.addInput(input)
        
        /// 미리보기 추가
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(preview, at: 0)
        self.previewLayer = preview
        
        /// 세션 실행
        session.startRunning()
        
        
    }
    
    /// 레이아웃이 확정된 이후 처리하기 위해서 사용
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
 

}

// MARK:  카메라 설정
extension TestViewController {
    
    
}
