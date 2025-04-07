//
//  VideoViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit
import AVFoundation
import AVKit


class VideoCaptureViewController: UIViewController {
    
    // MARK: - 속성
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureMovieFileOutput!
    private var recordedVideos: [URL] = []
    private var currentQuality: AVCaptureSession.Preset = .high
    private var currentAspectRatio: String = "9:16"
    
    // MARK: - UI 요소
    private let previewView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 6
        button.layer.borderColor = UIColor.red.cgColor
        return button
    }()
    
    private lazy var folderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "folder"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(showFolder), for: .touchUpInside)
        return button
    }()
    
    private let settingsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        return view
    }()
    
    private lazy var qualityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("HD", for: .normal)
        button.addTarget(self, action: #selector(toggleQuality), for: .touchUpInside)
        return button
    }()
    
    private lazy var aspectRatioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("9:16", for: .normal)
        button.addTarget(self, action: #selector(toggleAspectRatio), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestCameraPermission()
        
        Task {
            await setupCamera()
            await MainActor.run {
                updatePreviewLayerFrame()
            }
        }
    }
    
    // MARK: - 카메라 설정
    private func setupCamera() async {
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            await Task.detached(priority: .userInitiated) {
                self.captureSession.beginConfiguration()
                if self.captureSession.canAddInput(videoInput) {
                    self.captureSession.addInput(videoInput)
                }
                if self.captureSession.canAddInput(audioInput) {
                    self.captureSession.addInput(audioInput)
                }
                
                self.videoOutput = AVCaptureMovieFileOutput()
                if self.captureSession.canAddOutput(self.videoOutput) {
                    self.captureSession.addOutput(self.videoOutput)
                }
                self.captureSession.sessionPreset = self.currentQuality
                self.captureSession.commitConfiguration()
                
                self.captureSession.startRunning()
            }.value
            
            await MainActor.run {
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.videoPreviewLayer.videoGravity = .resizeAspect // 깜박임 완화 시도
                self.previewView.layer.addSublayer(self.videoPreviewLayer)
            }
        } catch {
            print("카메라 설정 오류: \(error)")
        }
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(settingsView)
        view.addSubview(previewView)
        view.addSubview(recordButton)
        view.addSubview(folderButton)
        
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        settingsView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        settingsView.addSubview(aspectRatioButton)
        aspectRatioButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        settingsView.addSubview(qualityButton)
        qualityButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        previewView.snp.makeConstraints { make in
            make.top.equalTo(settingsView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
        }
        
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(70)
        }
        recordButton.addTarget(self, action: #selector(handleRecordButton), for: .touchUpInside)
        
        folderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(recordButton)
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - 프리뷰 레이어 프레임 업데이트
    private func updatePreviewLayerFrame() {
        guard videoPreviewLayer != nil else { return }
        let bounds = previewView.bounds
        
        switch currentAspectRatio {
        case "16:9":
            videoPreviewLayer.frame = bounds
        case "4:3":
            let height = bounds.width * 3 / 4
            videoPreviewLayer.frame = CGRect(x: 0, y: (bounds.height - height) / 2, width: bounds.width, height: height)
        case "1:1":
            let size = min(bounds.width, bounds.height)
            videoPreviewLayer.frame = CGRect(x: (bounds.width - size) / 2, y: (bounds.height - size) / 2, width: size, height: size)
        case "9:16":
            let width = bounds.height * 9 / 16
            videoPreviewLayer.frame = CGRect(x: (bounds.width - width) / 2, y: 0, width: width, height: bounds.height)
        default:
            videoPreviewLayer.frame = bounds
        }
    }
    
    // MARK: - 동작
    @objc private func handleRecordButton() {
        Task { @MainActor in
            if videoOutput.isRecording {
                videoOutput.stopRecording()
                recordButton.backgroundColor = .white
            } else {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = "video_\(Date().timeIntervalSince1970).mov"
                let fileURL = documentsPath.appendingPathComponent(fileName)
                
                videoOutput.startRecording(to: fileURL, recordingDelegate: self)
                recordButton.backgroundColor = .red
            }
        }
    }
    
    @objc private func toggleQuality() {
        Task { @MainActor in
            // 페이드 아웃 효과
            UIView.animate(withDuration: 0.3, animations: {
                self.previewView.alpha = 0.0
            }) { _ in
                // 세션 상태 확인
                let isRunning = self.captureSession.isRunning
                if isRunning {
                    self.captureSession.stopRunning()
                }
                
                // 품질 전환
                self.captureSession.beginConfiguration()
                if self.currentQuality == .high {
                    self.currentQuality = .hd4K3840x2160
                    self.qualityButton.setTitle("4K", for: .normal)
                } else {
                    self.currentQuality = .high
                    self.qualityButton.setTitle("HD", for: .normal)
                }
                self.captureSession.sessionPreset = self.currentQuality
                self.captureSession.commitConfiguration()
                
                // 세션 재시작
                if isRunning {
                    self.captureSession.startRunning()
                }
                
                // 프리뷰 레이어 갱신
                self.updatePreviewLayerFrame()
                
                // 페이드 인 효과
                UIView.animate(withDuration: 0.3) {
                    self.previewView.alpha = 1.0
                }
            }
        }
    }
    
    @objc private func toggleAspectRatio() {
        let ratios = ["9:16", "16:9", "4:3", "1:1"]
        let currentIndex = ratios.firstIndex(of: currentAspectRatio) ?? 0
        let nextIndex = (currentIndex + 1) % ratios.count
        currentAspectRatio = ratios[nextIndex]
        aspectRatioButton.setTitle(currentAspectRatio, for: .normal)
        updatePreviewLayerFrame()
    }
    
    @objc private func showFolder() {
        let videoListVC = VideoListViewController(videoURLs: recordedVideos)
        videoListVC.modalPresentationStyle = .formSheet
        present(videoListVC, animated: true)
    }
    
    @objc private func close() {
        dismiss(animated: true)
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
            self.folderButton.isHidden = self.recordedVideos.isEmpty
        }
    }
}

// MARK: - 동영상 목록 뷰 컨트롤러
class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let videoURLs: [URL]
    private let tableView = UITableView()
    
    init(videoURLs: [URL]) {
        self.videoURLs = videoURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않았습니다")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VideoThumbnailCell.self, forCellReuseIdentifier: "VideoThumbnailCell")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "저장된 동영상"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoThumbnailCell", for: indexPath) as! VideoThumbnailCell
        let videoURL = videoURLs[indexPath.row]
        cell.configure(with: videoURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = videoURLs[indexPath.row]
        let player = AVPlayer(url: videoURL)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            player.play()
        }
    }
}

// MARK: - 커스텀 테이블 뷰 셀
class VideoThumbnailCell: UITableViewCell {
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않았습니다")
    }
    
    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(160)
            make.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with videoURL: URL) {
        titleLabel.text = videoURL.lastPathComponent
        
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        Task { [weak self] in
            do {
                let cgImage = try await imageGenerator.image(at: time).image
                let uiImage = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = uiImage
                }
            } catch {
                print("썸네일 생성 오류: \(error)")
            }
        }
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
