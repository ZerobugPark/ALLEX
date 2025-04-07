//
//  VideoCaptureViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit
@preconcurrency  import AVFoundation
import AVKit

import RxSwift
import RxCocoa

class VideoCaptureViewController: BaseViewController<VideoCaptureView, VideoCaptureViewModel> {
    
    // MARK: - 속성
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureMovieFileOutput!
    private var recordedVideos: [URL] = []
    private var currentQuality: AVCaptureSession.Preset = .high
    

    var coordinator: CameraCoordinator?
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraPermission()
        
        Task {
            await setupCamera()
            await MainActor.run {
                updatePreviewLayerFrame()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreviewLayerFrame()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    override func bind() {
        
        
        mainView.closeButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.dismiss()
        }.disposed(by: disposeBag)
        
        mainView.qualityButton.rx.tap.bind(with: self) { owner, _ in
            owner.toggleQuality()
        }.disposed(by: disposeBag)
        
        mainView.recordButton.recordButton.rx.tap.bind(with: self) { owner, _ in
            owner.handleRecordButton()
        }.disposed(by: disposeBag)
        
        mainView.folderButton.rx.tap.bind(with: self) { owner, _ in
            owner.showFolder()
        }.disposed(by: disposeBag)
        
        
    }
    // MARK: - 카메라 설정 (Swift 5 동시성 개선)
    private func setupCamera() async {
        // 카메라와 오디오 장치 확인
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("카메라 또는 오디오 장치를 찾을 수 없습니다")
            return
        }
        
        do {
            // 비디오 및 오디오 입력 생성
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            // 세션 구성 및 시작 - 반드시 백그라운드 스레드에서 실행
            await withCheckedContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    // 1. 세션 구성
                    self.captureSession.beginConfiguration()
                    
                    // 비디오 입력 추가
                    if self.captureSession.canAddInput(videoInput) {
                        self.captureSession.addInput(videoInput)
                    }
                    
                    // 오디오 입력 추가
                    if self.captureSession.canAddInput(audioInput) {
                        self.captureSession.addInput(audioInput)
                    }
                    
                    // 비디오 출력 설정
                    self.videoOutput = AVCaptureMovieFileOutput()
                    if self.captureSession.canAddOutput(self.videoOutput) {
                        self.captureSession.addOutput(self.videoOutput)
                    }
                    
                    // 세션 프리셋 설정
                    self.captureSession.sessionPreset = self.currentQuality
                    self.captureSession.commitConfiguration()
                    
                    // 2. 세션 시작 - 반드시 백그라운드 스레드에서 호출
                    // Apple 문서: startRunning은 시간이 오래 걸릴 수 있으므로
                    // 메인 스레드에서 호출하면 안 됨
                    self.captureSession.startRunning()
                    
                    continuation.resume()
                }
            }
            
            // UI 업데이트는 메인 스레드에서 실행
            await MainActor.run {
                // 비디오 프리뷰 레이어 설정
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.videoPreviewLayer.videoGravity = .resizeAspect
                self.mainView.previewView.layer.addSublayer(self.videoPreviewLayer)
            }
        } catch {
            await MainActor.run {
                print("카메라 설정 오류: \(error)")
                self.showAlert(title: "카메라 오류", message: "카메라를 설정하는 중 문제가 발생했습니다: \(error.localizedDescription)")
            }
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    

    private func updatePreviewLayerFrame() {
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        
        let bounds = mainView.previewView.bounds
        let targetAspectRatio: CGFloat = 4.0 / 3.0
        
        let width = bounds.height * targetAspectRatio 
        let xOffset = (bounds.width - width) / 2
        videoPreviewLayer.frame = CGRect(x: xOffset, y: 0, width: width, height: bounds.height)
        
        print("적용된 비율: \(targetAspectRatio), 프레임: \(videoPreviewLayer.frame), previewView bounds: \(bounds)")
    }
  
    // MARK: - 동작
    private func handleRecordButton() {
        Task { @MainActor in
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
    
    private func toggleQuality() {
        Task {
            // 페이드 아웃 효과 - UI 관련 작업은 메인 스레드에서
            await MainActor.run {
                UIView.animate(withDuration: 0.3) {
                    self.mainView.previewView.alpha = 0.0
                }
            }
            
            // 애니메이션이 완료될 때까지 대기
            try? await Task.sleep(nanoseconds: UInt64(0.3 * 1_000_000_000))
            
            // 세션 상태 확인
            let isRunning = self.captureSession.isRunning
            let newQuality: AVCaptureSession.Preset = self.currentQuality == .high ? .hd4K3840x2160 : .high
            let qualityTitle = newQuality == .high ? "HD" : "4K"
            
            // 백그라운드 스레드에서 카메라 작업 수행
            await withCheckedContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    // 세션 중지 (필요한 경우)
                    if isRunning {
                        self.captureSession.stopRunning()
                    }
                    
                    // 품질 전환
                    self.captureSession.beginConfiguration()
                    self.currentQuality = newQuality
                    self.captureSession.sessionPreset = self.currentQuality
                    self.captureSession.commitConfiguration()
                    
                    // 세션 재시작 (필요한 경우)
                    if isRunning {
                        self.captureSession.startRunning()
                    }
                    
                    continuation.resume()
                }
            }
            
            // UI 업데이트는 메인 스레드에서
            await MainActor.run {
                // 품질 버튼 텍스트 업데이트
                self.mainView.qualityButton.setTitle(qualityTitle, for: .normal)
                
                // 프리뷰 레이어 갱신
                self.updatePreviewLayerFrame()
                
                // 페이드 인 효과
                UIView.animate(withDuration: 0.3) {
                    self.mainView.previewView.alpha = 1.0
                }
            }
        }
    }


    
    private func showFolder() {
        let videoListVC = VideoListViewController(videoURLs: recordedVideos)
        videoListVC.modalPresentationStyle = .formSheet
        present(videoListVC, animated: true)
    }
    

    // MARK: - 카메라 권한 요청
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    DispatchQueue.main.async {
                        self.showPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert()
        @unknown default:
            showPermissionAlert()
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "카메라 권한 필요",
            message: "설정에서 카메라 접근을 허용해주세요",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension VideoCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("녹화 오류: \(error)")
            return
        }
        
        recordedVideos.append(outputFileURL)
        print("동영상이 저장됨: \(outputFileURL)")
        DispatchQueue.main.async {
            self.mainView.folderButton.isHidden = self.recordedVideos.isEmpty
        }
    }
}


