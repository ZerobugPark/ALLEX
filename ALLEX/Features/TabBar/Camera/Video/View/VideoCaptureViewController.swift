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
    private var recordedVideos: [URL] = []
    private var currentQuality: AVCaptureSession.Preset = .high
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") /// 전역 큐 설정
    var coordinator: CameraCoordinator?
    
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
            selectedGrade: mainView.gradeCollectionView.rx.modelSelected(BoulderingAttempt.self).asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.closeButton.rx.tap.bind(with: self) { owner, _ in
            Task { @MainActor in
                
                if owner.recordedVideos.isEmpty {
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
            }
            
            owner.handleRecordButton()
        }.disposed(by: disposeBag)
        

        
        mainView.aspectRatioButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.aspectRatio = owner.mainView.aspectRatio.next
        }.disposed(by: disposeBag)
        
        
        output.currentColor.drive(with: self) { owner, color in
            owner.mainView.recordButton.recordButton.backgroundColor = .setBoulderColor(from: color)
            owner.mainView.gradeCollectionView.isHidden = true
        }.disposed(by: disposeBag)


//        mainView.folderButton.rx.tap.bind(with: self) { owner, _ in
//            owner.showFolder()
//        }.disposed(by: disposeBag)
        
        
        
        mainView.gradeButton.rx.tap.bind(with: self) { owner, _ in
            owner.mainView.gradeCollectionView.isHidden.toggle()
        }.disposed(by: disposeBag)
      
        
        output.gymGrade.drive(mainView.gradeCollectionView.rx.items(cellIdentifier: VideoGradeCell.id, cellType: VideoGradeCell.self)) { item, element, cell in
            
            cell.setupData(element)
            
        }.disposed(by: disposeBag)
        
        
        
            
//        mainView.gradeCollectionView.rx.modelSelected(BoulderingAttempt.self).bind(with: self) { owner, value in
//            owner.mainView.recordButton.recordButton.backgroundColor = .setBoulderColor(from: value.color)
//        }.disposed(by: disposeBag)
    }
    

    
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "안내", message: "기록을 저장하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "저장", style: .default))
        alert.addAction(UIAlertAction(title: "저장히지 않음", style: .destructive))
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
        let videoListVC = VideoListViewController(videoURLs: recordedVideos)
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

        // iOS 16+ 기준: 비동기 처리로 후보정 후 저장
        Task { [weak self] in
            guard let self = self else { return }
            await self.processAndSaveVideoAsync(originalURL: outputFileURL, ratio: self.mainView.aspectRatio)
        }
    }

    /// iOS 16+ 전제: 비디오를 선택된 비율로 센터 크롭/리사이즈 후 저장
    private func processAndSaveVideoAsync(originalURL: URL, ratio: VideoAspectRatio) async {
        
        /// 원본인 경우 그냥 저장
        if ratio == .ratio9x16 {
            recordedVideos.append(originalURL)
            saveVideoToPhotoLibrary(originalURL)
            await MainActor.run {
                self.mainView.folderButton.isHidden = self.recordedVideos.isEmpty
                self.mainView.qualityButton.isHidden = false
                self.mainView.aspectRatioButton.isHidden = false
            }
            return
        }

        let asset = AVAsset(url: originalURL)

        // 1) 메타 로딩 (iOS 16+ async APIs)
        let assetDuration = (try? await asset.load(.duration)) ?? .zero
        let videoTrack = try? await asset.loadTracks(withMediaType: .video).first
        guard let videoTrack else {
            print("비디오 트랙을 찾을 수 없습니다")
            self.saveVideoToPhotoLibrary(originalURL)
            return
        }
        let naturalSize = (try? await videoTrack.load(.naturalSize)) ?? .zero
        /// preferredTransform: 카메라 센서가 내보낸 버퍼의 회전/미러링 정보
        let preferredTransform = (try? await videoTrack.load(.preferredTransform)) ?? .identity

        // FPS 계산: nominalFrameRate > 0 우선, 없으면 minFrameDuration
        let fps: Double = await {
            if let nfr = try? await videoTrack.load(.nominalFrameRate), nfr > 0 { return Double(nfr) }
            if let mfd = try? await videoTrack.load(.minFrameDuration), mfd.isValid, mfd.seconds > 0 { return 1.0 / mfd.seconds }
            return 30
        }()

        // 2) 타깃 렌더 사이즈 (짧은 변 1080, enum 기준)
        let targetSize = ratio.renderSize(shortSide: 1080)

        // 3) 원본 디스플레이 사이즈(orientation 반영)
        let isPortrait = (preferredTransform.a == 0 && abs(preferredTransform.b) == 1 && abs(preferredTransform.c) == 1 && preferredTransform.d == 0)
        let sourceDisplaySize = isPortrait ? CGSize(width: naturalSize.height, height: naturalSize.width) : naturalSize

        // 4) 센터 크롭 스케일/이동
        let targetAspect = targetSize.width / targetSize.height
        let sourceAspect = sourceDisplaySize.width / sourceDisplaySize.height
        let scale: CGFloat = (sourceAspect > targetAspect)
            ? (targetSize.height / sourceDisplaySize.height)
            : (targetSize.width  / sourceDisplaySize.width)
        let scaledW = sourceDisplaySize.width * scale
        let scaledH = sourceDisplaySize.height * scale
        let tx = (targetSize.width  - scaledW)  * 0.5
        let ty = (targetSize.height - scaledH) * 0.5

        // 5) 합성 구성 (오디오 패스스루)
        let composition = AVMutableComposition()
        guard let compVideo = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            print("합성 비디오 트랙 생성 실패")
            self.saveVideoToPhotoLibrary(originalURL)
            return
        }
        do {
            try compVideo.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: videoTrack, at: .zero)
            compVideo.preferredTransform = .identity
        } catch {
            print("비디오 트랙 삽입 실패: \(error)")
            self.saveVideoToPhotoLibrary(originalURL)
            return
        }

        if let aTrack = try? await asset.loadTracks(withMediaType: .audio).first,
           let compAudio = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            try? compAudio.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: aTrack, at: .zero)
        }

        // 6) 비디오 합성 인스트럭션 (회전 → 스케일 → 이동)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: assetDuration)
        let layer = AVMutableVideoCompositionLayerInstruction(assetTrack: compVideo)
        var transform = preferredTransform
        transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
        transform = transform.concatenating(CGAffineTransform(translationX: tx, y: ty))
        layer.setTransform(transform, at: .zero)
        instruction.layerInstructions = [layer]

        let videoComp = AVMutableVideoComposition()
        videoComp.renderSize = CGSize(width: round(targetSize.width), height: round(targetSize.height))
        videoComp.frameDuration = CMTime(value: 1, timescale: CMTimeScale(max(fps, 1)))
        videoComp.instructions = [instruction]

        // 7) 익스포트
        let filenameSuffix: String = {
            switch ratio {
            case .ratio9x16: return "_9x16"
            case .ratio4x5:  return "_4x5"
            }
        }()
        
        let outURL: URL = {
            let dir = FileManager.default.temporaryDirectory
            let name = "export_\(Int(Date().timeIntervalSince1970))\(filenameSuffix).mp4"
            return dir.appendingPathComponent(name)
        }()

        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("Exporter 생성 실패")
            self.saveVideoToPhotoLibrary(originalURL)
            return
        }
        exporter.outputURL = outURL
        exporter.outputFileType = .mp4
        exporter.videoComposition = videoComp
        exporter.shouldOptimizeForNetworkUse = true

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            exporter.exportAsynchronously {
                continuation.resume()
            }
        }

        switch exporter.status {
        case .completed:
            print("Export 완료: \(outURL)")
            self.recordedVideos.append(outURL)
            self.saveVideoToPhotoLibrary(outURL)
            try? FileManager.default.removeItem(at: originalURL)
            await MainActor.run {
                self.mainView.folderButton.isHidden = self.recordedVideos.isEmpty
                self.mainView.qualityButton.isHidden = false
                self.mainView.aspectRatioButton.isHidden = false
            }
        case .failed, .cancelled:
            print("Export 실패: \(exporter.error?.localizedDescription ?? "unknown") — 원본 저장 시도")
            self.recordedVideos.append(originalURL)
            self.saveVideoToPhotoLibrary(originalURL)
            await MainActor.run {
                self.mainView.folderButton.isHidden = self.recordedVideos.isEmpty
                self.mainView.qualityButton.isHidden = false
                self.mainView.aspectRatioButton.isHidden = false
            }
        default:
            break
        }
    }

    private func saveVideoToPhotoLibrary(_ fileURL: URL) {
   
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
    
    }
}
