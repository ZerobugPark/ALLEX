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
    
    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureMovieFileOutput!
    private var recordedVideos: [URL] = []
    private var currentQuality: AVCaptureSession.Preset = .high
    
    // MARK: - UI Elements
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("촬영 시작", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
        checkCameraAuthorization()
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if captureSession.canAddInput(videoInput) && captureSession.canAddInput(audioInput) {
                captureSession.addInput(videoInput)
                captureSession.addInput(audioInput)
            }
            
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = view.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.sessionPreset = currentQuality
            captureSession.startRunning()
        } catch {
            print("Camera setup error: \(error)")
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // 설정 뷰
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let qualityStack = createQualityButtons()
        settingsView.addSubview(qualityStack)
        qualityStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qualityStack.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor),
            qualityStack.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 10)
        ])
        
        // 촬영 버튼
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        recordButton.addTarget(self, action: #selector(handleRecordButton), for: .touchUpInside)
        
        // 폴더 버튼
        view.addSubview(folderButton)
        folderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            folderButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            folderButton.widthAnchor.constraint(equalToConstant: 40),
            folderButton.heightAnchor.constraint(equalToConstant: 40)
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
        captureSession.beginConfiguration()
        captureSession.sessionPreset = currentQuality
        captureSession.commitConfiguration()
    }
    
    @objc private func showFolder() {
        let videoListVC = VideoListViewController(videoURLs: recordedVideos)
        videoListVC.modalPresentationStyle = .formSheet
        present(videoListVC, animated: true)
    }
    
    // MARK: - Authorization
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    DispatchQueue.main.async { self.showPermissionAlert() }
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
        
        recordedVideos.append(outputFileURL)
        print("Video saved at: \(outputFileURL)")
        folderButton.isHidden = recordedVideos.isEmpty
    }
}

// MARK: - Video List View Controller
class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let videoURLs: [URL]
    private let tableView = UITableView()
    
    init(videoURLs: [URL]) {
        self.videoURLs = videoURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VideoCell")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "저장된 동영상"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        let videoURL = videoURLs[indexPath.row]
        cell.textLabel?.text = videoURL.lastPathComponent
        return cell
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
