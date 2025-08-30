//
//  VideoCaptureViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit
import AVFoundation

import RxSwift
import RxCocoa
import Photos


enum VideoAspectRatio {
    case ratio9x16
    case ratio4x5
    
    /// 가로:세로 비율 (예: 16:9 → 16/9)
    var value: CGFloat {
        switch self {
        case .ratio9x16: return 9.0 / 16.0
        case .ratio4x5:  return 4.0 / 5.0
        }
    }
    
    var next: VideoAspectRatio {
        switch self {
        case .ratio9x16: return .ratio4x5
        case .ratio4x5:  return .ratio9x16
        }
    }
    
    /// 짧은 변 기준 해상도에서 타깃 사이즈 계산
    func renderSize(shortSide: CGFloat) -> CGSize {
        switch self {
        case .ratio9x16:
            return CGSize(width: shortSide, height: shortSide * 16.0/9.0)
        case .ratio4x5:
            return CGSize(width: shortSide, height: shortSide * 5.0/4.0)
        }
    }
    
    /// UI 표시용 문자열
    var title: String {
        switch self {
        case .ratio9x16: return "9:16"
        case .ratio4x5:  return "4:5"
        }
    }
}

class VideoCaptureViewController: BaseViewController<VideoCaptureView, VideoCaptureViewModel> {
    
    // MARK: - 속성
    private let session = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput!
    
    private var currentQuality: AVCaptureSession.Preset = .high
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") /// 전역 큐 설정
    var coordinator: CameraCoordinator?
    private let editVideo = PublishRelay<[Int : [URL]]>()
    private let savedVideo = PublishRelay<(URL, VideoAspectRatio)>()
    private let savedRecord = PublishRelay<Void>()
    
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissionAndSetupCamera()
        
        mainView.gradeCollectionView.register(VideoGradeCell.self, forCellWithReuseIdentifier: VideoGradeCell.reuseId)
        
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
        
        let input = VideoCaptureViewModel.Input(
            selectedGrade: mainView.gradeCollectionView.rx.modelSelected(BoulderingAttempt.self).asDriver(),
            savedVideo: savedVideo.asDriver(onErrorDriveWith: .empty()),
            editVideo: editVideo.asDriver(onErrorDriveWith: .empty()),
            recordedButton: mainView.recordButton.recordingButton.rx.tap,
            savedRecord: savedRecord.asDriver(onErrorJustReturn: ()),
            
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.closeButton.rx.tap.bind(with: self) { owner, _ in
            Task { @MainActor in
                
                if owner.viewModel.recordedVideos.isEmpty {
                    owner.coordinator?.dismiss()
                } else {
                    owner.showAlert()
                }
                
            }
        }.disposed(by: disposeBag)

        mainView.qualityButton.rx.tap.bind(with: self) { owner, _ in
            owner.toggleQuality()
        }.disposed(by: disposeBag)
        
        Observable.of(
            mainView.recordButton.recordButton.rx.tap,
            mainView.recordButton.recordingButton.rx.tap
        ).merge().bind(with: self) { owner, _ in
            /// 촬영 중에는 해상도 및 비율 바꾸기 금지
            Task { @MainActor in
                owner.mainView.qualityButton.isHidden = true
                owner.mainView.aspectRatioButton.isHidden = true
                owner.mainView.folderButton.isHidden = true
                owner.mainView.gradeButton.isHidden = true
            }
            
            owner.handleRecordButton()
        }.disposed(by: disposeBag)
        

        
        mainView.aspectRatioButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.aspectRatio = owner.mainView.aspectRatio.next
            
            if owner.mainView.aspectRatio == .ratio4x5 {
                if owner.currentQuality == .hd4K3840x2160 {
                    owner.toggleQuality()
                }
            }
            
       
            
        }.disposed(by: disposeBag)
        
        
        output.currentColor.drive(with: self) { owner, color in
            owner.mainView.recordButton.recordButton.backgroundColor = .setBoulderColor(from: color)
            owner.mainView.gradeCollectionView.isHidden = true
        }.disposed(by: disposeBag)


        mainView.folderButton.rx.tap.bind(with: self) { owner, _ in
            owner.showFolder()
        }.disposed(by: disposeBag)
        
        
        
        mainView.gradeButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.gradeCollectionView.isHidden.toggle()
        }.disposed(by: disposeBag)
      
        
        output.gymGrade.drive(mainView.gradeCollectionView.rx.items(cellIdentifier: VideoGradeCell.id, cellType: VideoGradeCell.self)) { item, element, cell in
            
            cell.setupData(element)
            
        }.disposed(by: disposeBag)
        
        output.finisehdVideo.drive(with: self) { owner, _ in
            
            owner.mainView.folderButton.isHidden = owner.viewModel.recordedVideos.isEmpty
            owner.mainView.qualityButton.isHidden = false
            owner.mainView.aspectRatioButton.isHidden = false
            owner.mainView.gradeButton.isHidden = false
            
        }.disposed(by: disposeBag)
        
        
        output.dismissView.drive(with: self) { owner, _ in
            
            owner.coordinator?.showDetail(mode: .latest)
            
        }.disposed(by: disposeBag)
        
    }
    

    
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "안내", message: "기록을 저장하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { [weak self] _ in
            self?.savedRecord.accept(())
        }))
        alert.addAction(UIAlertAction(title: "저장하지 않음", style: .destructive, handler: { [weak self] _ in
            self?.coordinator?.dismiss()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
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
        sessionQueue.async { [weak self] in
            
            guard let self else { return }
            
            
            /// 세션 설정
            session.sessionPreset = .high // FHD
            
            /// 카메라 입력
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else {
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
            DispatchQueue.main.async { [weak self] in
                self?.mainView.previewView.videoPreviewLayer.session = self?.session
            }
            

            /// 세션 실행
            self.session.startRunning()
            
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
                mainView.recordButton.recordButton.backgroundColor = .setBoulderColor(from: viewModel.color)
                mainView.recordButton.recordButton.isHidden = false
                mainView.recordButton.recordingButton.isHidden = true
            } else {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = "video_\(Date().timeIntervalSince1970).mov"
                let fileURL = documentsPath.appendingPathComponent(fileName)
                videoOutput.startRecording(to: fileURL, recordingDelegate: self)
                mainView.recordButton.recordButton.isHidden = true
                mainView.recordButton.recordingButton.isHidden = false
            }
        }
    }
    
    private func showFolder() {
        
        let videoListVC = VideoListViewController(recordedVideos: viewModel.recordedVideos) { [weak self] videoData in
            self?.editVideo.accept(videoData)
        }
        videoListVC.modalPresentationStyle = .formSheet
        present(videoListVC, animated: true)
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
        
      
        self.sessionQueue.async { [weak self] in
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

// MARK: - AVCaptureFileOutputRecordingDelegate
// iOS 16+ async/AVAssetExport 기반 구현 (후보정 및 비율 적용)
extension VideoCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("녹화 오류: \(error)")
            return
        }

        savedVideo.accept((outputFileURL, self.mainView.aspectRatio))
    }
}
