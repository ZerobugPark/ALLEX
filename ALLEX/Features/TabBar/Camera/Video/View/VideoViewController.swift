//
//  VideoViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit
import AVFoundation

class VideoCaptureViewController: UIViewController {
    
    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureMovieFileOutput!
    
    private var currentQuality: AVCaptureSession.Preset = .high
    private var currentRatio: CGSize = CGSize(width: 16, height: 9)
    
    // MARK: - UI Elements
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("촬영 시작", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(VideoCaptureViewController.self, action: #selector(handleRecordButton), for: .touchUpInside)
        return button
    }()
    
    private let settingsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
        checkCameraAuthorization()
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        // 카메라 입력 설정
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if captureSession.canAddInput(videoInput) && captureSession.canAddInput(audioInput) {
                captureSession.addInput(videoInput)
                captureSession.addInput(audioInput)
            }
            
            // 비디오 출력 설정
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            // 프리뷰 레이어 설정
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = view.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
        } catch {
            print("Camera setup error: \(error)")
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // 설정 뷰 추가
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // 화질 선택 버튼들
        let qualityStack = createQualityButtons()
        settingsView.addSubview(qualityStack)
        qualityStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qualityStack.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
            qualityStack.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 10)
        ])
        
        // 촬영 버튼 추가
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createQualityButtons() -> UIStackView {
        let qualities: [(String, AVCaptureSession.Preset)] = [
            ("HD", .high),
            ("4K", .hd4K3840x2160),
            ("Low", .low)
        ]
        
        let buttons = qualities.map { title, preset in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(changeQuality(_:)), for: .touchUpInside)
            button.tag = qualities.firstIndex(where: { $1 == preset }) ?? 0
            return button
        }
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }
    
    // MARK: - Actions
    @objc private func handleRecordButton() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
            recordButton.setTitle("촬영 시작", for: .normal)
        } else {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = "video_\(Date().timeIntervalSince1970).mov"
            let fileURL = documentsPath.appendingPathComponent(fileName)
            
            videoOutput.startRecording(to: fileURL, recordingDelegate: self)
            recordButton.setTitle("촬영 중지", for: .normal)
        }
    }
    
    @objc private func changeQuality(_ sender: UIButton) {
        let qualities: [AVCaptureSession.Preset] = [.high, .hd4K3840x2160, .low]
        currentQuality = qualities[sender.tag]
        captureSession.sessionPreset = currentQuality
    }
    
    // MARK: - Authorization
    private func checkCameraAuthorization() {
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
        default:
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
            print("Recording error: \(error)")
            return
        }
        print("Video saved at: \(outputFileURL)")
        // 여기서 추가 작업 가능 (예: 썸네일 생성, 파일 관리 등)
    }
}

//final class VideoViewController: BaseViewController<VideoView, VideoViewModel> {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//    
//        view.backgroundColor = .blue
//    }
//    
//
// 
//
//}
