//
//  VideoCaptureViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit
import AVFoundation
//import AVKit

import RxSwift
import RxCocoa
import Photos
class VideoCaptureViewController: BaseViewController<VideoCaptureView, VideoCaptureViewModel> {
    
    // MARK: - 속성
    private let session = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput!
    private var recordedVideos: [URL] = []
    private var currentQuality: AVCaptureSession.Preset = .high
    
    
    var coordinator: CameraCoordinator?
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissionAndSetupCamera()
        
        //        Task {
        //            await setupCamera()
        //            await MainActor.run {
        //                updatePreviewLayerFrame()
        //            }
        //        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    /// 레이아웃이 확정된 이후 처리하기 위해서 사용
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //updatePreviewLayerFrame()
        
        
        //previewLayer?.frame = mainView.previewView.bounds
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func bind() {
        
        
        //        mainView.closeButton.rx.tap.bind(with: self) { owner, _ in
        //            owner.coordinator?.dismiss()
        //        }.disposed(by: disposeBag)
        //
        mainView.qualityButton.rx.tap.bind(with: self) { owner, _ in
            owner.toggleQuality()
        }.disposed(by: disposeBag)
        
        mainView.recordButton.recordButton.rx.tap.bind(with: self) { owner, _ in
            /// 촬영 중에는 해상도 바꾸기 금지
            Task { @MainActor in
                owner.mainView.qualityButton.isHidden = true
            }
            
            owner.handleRecordButton()
        }.disposed(by: disposeBag)
        //
        //        mainView.folderButton.rx.tap.bind(with: self) { owner, _ in
        //            owner.showFolder()
        //        }.disposed(by: disposeBag)
        
        
    }
    
}

extension VideoCaptureViewController {
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
        
        // 오디오 입력 추가
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            if let audioInput = try? AVCaptureDeviceInput(device: audioDevice), session.canAddInput(audioInput) {
                session.addInput(audioInput)
            }
        }

        // 비디오 출력 연결 (녹화용)
        let movieOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
            self.videoOutput = movieOutput
            if let conn = movieOutput.connection(with: .video), conn.isVideoStabilizationSupported {
                conn.preferredVideoStabilizationMode = .auto
            }
        } else {
            print("movieOutput를 세션에 추가할 수 없습니다")
        }
        
        /// 미리보기 추가
        mainView.previewView.videoPreviewLayer.session = session
        
        
        /// 세션 실행
        Task {
            session.startRunning()
        }
        
        
        
        
    }
    
    
    
    private func handleRecordButton() {
        Task { @MainActor in
            guard let videoOutput = self.videoOutput else {
                print("videoOutput가 아직 준비되지 않았습니다. setupCamera() 후 다시 시도해주세요.")
                return
            }
            if videoOutput.isRecording {
                videoOutput.stopRecording()
                mainView.recordButton.recordButton.backgroundColor = .yellow
            } else {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = "video_\(Date().timeIntervalSince1970).mov"
                let fileURL = documentsPath.appendingPathComponent(fileName)
                videoOutput.startRecording(to: fileURL, recordingDelegate: self)
                mainView.recordButton.recordButton.backgroundColor = .red
            }
        }
    }
    

}


// MARK:  Utility

private extension VideoCaptureViewController {
    func toggleQuality() {
        let newQuality: AVCaptureSession.Preset = (self.currentQuality == .high) ? .hd4K3840x2160 : .high
        let qualityTitle = (newQuality == .high) ? "HD" : "4K"
        
        // Snapshot the current preview to mask any stream hiccup
        
        ///현재 프리뷰 화면을 그대로 캡처한 정지 뷰(스냅샷)를 만든다.
        ///afterScreenUpdates: false → 레이아웃/렌더를 강제로 갱신하지 않고 지금 보이는 그대로를 캡처. 전환 시 성능/끊김에 유리.
        let snapshot = mainView.previewView.snapshotView(afterScreenUpdates: false)
        
        ///스냅샷의 프레임을 프리뷰 컨테이너(previewView)의 현재 크기와 정확히 일치시키는 줄.
        ///이유: 전환 동안 라이브 프리뷰를 이 스냅샷으로 완전히 덮어 깜빡임(블랙 프레임/해상도 재협상)을 가리기 위해.
        snapshot?.frame = mainView.previewView.bounds
        
        /// 전환 애니메이션 중에 회전/리사이즈가 생겨도 컨테이너 크기를 따라가도록 보폭 설정.
        /// 스냅샷은 오토레이아웃을 안 쓰므로, autoresizing으로 대응.
        snapshot?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        /// 스냅샷이 생성되었으면 프리뷰 위 맨 앞에 올려 덮는다. 이제 사용자는 라이브 스트림 대신 정지 화면을 보게 됨(깜빡임 가림 목적).
        if let snapshot { mainView.previewView.addSubview(snapshot) }
        
        // 1) Add blur (alpha fade only)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = mainView.previewView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        mainView.previewView.addSubview(blurView)
        
        UIView.animate(withDuration: 0.20) {
            blurView.alpha = 1.0
        }
        
        let sessionQueue = DispatchQueue(label: "camera.session.queue")
        sessionQueue.async { [weak self] in
            guard let self else { return }
            CATransaction.begin()
            
            /// 코어 애니메이션의 암묵적 애니메이션을 비활성화
            CATransaction.setDisableActions(true)
            self.session.beginConfiguration()
            if self.session.canSetSessionPreset(newQuality) {
                self.currentQuality = newQuality
                self.session.sessionPreset = newQuality
            }
            self.session.commitConfiguration()
            CATransaction.commit()
            
            // Back to main to cross-fade from snapshot to live
            DispatchQueue.main.async {
                self.mainView.qualityButton.setTitle(qualityTitle, for: .normal)
                UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseInOut]) {
                    snapshot?.alpha = 0.0
                    blurView.alpha = 0.0
                } completion: { _ in
                    snapshot?.removeFromSuperview()
                    blurView.removeFromSuperview()
                }
            }
            
            
        }
    }
}

//extension VideoCaptureViewController {
//    // MARK: - 카메라 설정 (Swift 5 동시성 개선)
//    private func setupCamera() async {
//        // 카메라와 오디오 장치 확인
//        guard let videoDevice = AVCaptureDevice.default(for: .video),
//              let audioDevice = AVCaptureDevice.default(for: .audio) else {
//            print("카메라 또는 오디오 장치를 찾을 수 없습니다")
//            return
//        }
//
//        do {
//            // 비디오 및 오디오 입력 생성
//            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
//            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
//
//            // 세션 구성 및 시작 - 반드시 백그라운드 스레드에서 실행
//            await withCheckedContinuation { continuation in
//                DispatchQueue.global(qos: .userInitiated).async {
//                    // 1. 세션 구성
//                    self.captureSession.beginConfiguration()
//
//                    // 비디오 입력 추가
//                    if self.captureSession.canAddInput(videoInput) {
//                        self.captureSession.addInput(videoInput)
//                    }
//
//                    // 오디오 입력 추가
//                    if self.captureSession.canAddInput(audioInput) {
//                        self.captureSession.addInput(audioInput)
//                    }
//
//                    // 비디오 출력 설정
//                    self.videoOutput = AVCaptureMovieFileOutput()
//                    if self.captureSession.canAddOutput(self.videoOutput) {
//                        self.captureSession.addOutput(self.videoOutput)
//                    }
//
//                    // 세션 프리셋 설정
//                    self.captureSession.sessionPreset = self.currentQuality
//                    self.captureSession.commitConfiguration()
//
//                    // 2. 세션 시작 - 반드시 백그라운드 스레드에서 호출
//                    // Apple 문서: startRunning은 시간이 오래 걸릴 수 있으므로
//                    // 메인 스레드에서 호출하면 안 됨
//                    self.captureSession.startRunning()
//
//                    continuation.resume()
//                }
//            }
//
//            // UI 업데이트는 메인 스레드에서 실행
//            await MainActor.run {
//                // 비디오 프리뷰 레이어 설정
//                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//                self.videoPreviewLayer.videoGravity = .resizeAspect
//                self.mainView.previewView.layer.addSublayer(self.videoPreviewLayer)
//            }
//        } catch {
//            await MainActor.run {
//                print("카메라 설정 오류: \(error)")
//                self.showAlert(title: "카메라 오류", message: "카메라를 설정하는 중 문제가 발생했습니다: \(error.localizedDescription)")
//            }
//        }
//    }
//    private func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alert, animated: true)
//    }
//
//
//    private func updatePreviewLayerFrame() {
//        guard let videoPreviewLayer = videoPreviewLayer else { return }
//
//        let bounds = mainView.previewView.bounds
//        let targetAspectRatio: CGFloat = 4.0 / 3.0
//
//        let width = bounds.height * targetAspectRatio
//        let xOffset = (bounds.width - width) / 2
//        videoPreviewLayer.frame = CGRect(x: xOffset, y: 0, width: width, height: bounds.height)
//
//        print("적용된 비율: \(targetAspectRatio), 프레임: \(videoPreviewLayer.frame), previewView bounds: \(bounds)")
//    }
//
//    // MARK: - 동작

//

//
//
//
//    private func showFolder() {
//        let videoListVC = VideoListViewController(videoURLs: recordedVideos)
//        videoListVC.modalPresentationStyle = .formSheet
//        present(videoListVC, animated: true)
//    }
//
//
//    // MARK: - 카메라 권한 요청
//    private func requestCameraPermission() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            break
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if !granted {
//                    DispatchQueue.main.async {
//                        self.showPermissionAlert()
//                    }
//                }
//            }
//        case .denied, .restricted:
//            showPermissionAlert()
//        @unknown default:
//            showPermissionAlert()
//        }
//    }
//
//    private func showPermissionAlert() {
//        let alert = UIAlertController(
//            title: "카메라 권한 필요",
//            message: "설정에서 카메라 접근을 허용해주세요",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alert, animated: true)
//    }
//}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension VideoCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("녹화 오류: \(error)")
            return
        }
        
        recordedVideos.append(outputFileURL)
        self.saveVideoToPhotoLibrary(outputFileURL)
        print("동영상이 저장됨: \(outputFileURL)")
        DispatchQueue.main.async {
            self.mainView.folderButton.isHidden = self.recordedVideos.isEmpty
            self.mainView.qualityButton.isHidden = false
        }
    }
    
    
    private func saveVideoToPhotoLibrary(_ fileURL: URL) {
        // iOS 14+: request add-only access; we don't need read permission
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                guard status == .authorized else {
                    print("사진 앱에 추가 권한이 없습니다: \(status)")
                    return
                }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                }) { success, error in
                    if let error = error {
                        print("갤러리 저장 실패: \(error)")
                    } else {
                        print("갤러리에 저장 완료: \(success)")
                    }
                }
            }
        } else {
            // iOS 13 이하: 일반 권한 요청
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    print("사진 앱 접근 권한이 없습니다: \(status)")
                    return
                }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                }) { success, error in
                    if let error = error {
                        print("갤러리 저장 실패: \(error)")
                    } else {
                        print("갤러리에 저장 완료: \(success)")
                    }
                }
            }
        }
    }
}
