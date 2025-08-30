//
//  PassthroughTrimViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 8/30/25.
//

import UIKit
import AVKit
import AVFoundation

import SnapKit

final class PassthroughTrimViewController: UIViewController {
    private let url: URL
    private let onComplete: (URL?) -> Void

    private let player = AVPlayer()
    private let playerVC = AVPlayerViewController()
    private var timeObserver: Any?
    private var duration: Double = 0

    private let startSlider = UISlider()
    private let endSlider = UISlider()
    private let startLabel = UILabel()
    private let endLabel = UILabel()
    
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    init(url: URL, onComplete: @escaping (URL?) -> Void) {
        self.url = url
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit {
        if let obs = timeObserver { player.removeTimeObserver(obs) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadAssetAndPrepare()
    }

    private func setupUI() {
        // Player
        addChild(playerVC)
        view.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)
        playerVC.player = player
        playerVC.showsPlaybackControls = true
        
  
        [startLabel, endLabel].forEach { lbl in
            lbl.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            lbl.textColor = .label
        }
        
        startLabel.textAlignment = .left
        endLabel.textAlignment = .right
            
        // Buttons
        saveButton.setTitle("저장", for: .normal)
        cancelButton.setTitle("취소", for: .normal)
        saveButton.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        
        // Add targets for sliders
        startSlider.addTarget(self, action: #selector(startChanged), for: .valueChanged)
        endSlider.addTarget(self, action: #selector(endChanged), for: .valueChanged)
        
        
        let controlsStack = UIStackView(arrangedSubviews: [startSlider, endSlider])
        controlsStack.axis = .vertical
        controlsStack.spacing = 12
        
        let labelsStack = UIStackView(arrangedSubviews: [startLabel, endLabel])
        labelsStack.axis = .horizontal
        labelsStack.distribution = .fillEqually
        
        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        
        view.addSubviews(labelsStack, controlsStack, buttonsStack)
    
        
        // Layout (SnapKit)
        playerVC.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        
        labelsStack.snp.makeConstraints { make in
            make.top.equalTo(playerVC.view.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        controlsStack.snp.makeConstraints { make in
            make.top.equalTo(labelsStack.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(controlsStack.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(44)
        }
        
    }
        
 
    private func loadAssetAndPrepare() {
        Task { @MainActor in
            let asset = AVAsset(url: url)
            let dur = (try? await asset.load(.duration)) ?? .zero
            duration = max(0, CMTimeGetSeconds(dur))

            player.replaceCurrentItem(with: AVPlayerItem(asset: asset))
            addTimeObserver()

            [startSlider, endSlider].forEach {
                $0.minimumValue = 0
                $0.maximumValue = Float(duration)
            }
            startSlider.value = 0
            endSlider.value = Float(duration)
            updateLabels()
        }
    }

    private func addTimeObserver() {
        /// preferredTimescale: 600 → 시간을 1/600초 단위로 표현(영상 도메인에서 흔히 쓰는 정밀도)
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            _ = CMTimeGetSeconds(time) // 재생 위치는 표시하지 않음 (start만 사용)
        }
    }

    @objc private func startChanged() {
        let minGap: Float = 0.1
        if startSlider.value > endSlider.value - minGap {
            startSlider.value = endSlider.value - minGap
        }
        updateLabels()
        seekAndAutoPlay(Double(startSlider.value))
    }

    @objc private func endChanged() {
        let minGap: Float = 0.1
        if endSlider.value < startSlider.value + minGap {
            endSlider.value = startSlider.value + minGap
        }
        updateLabels()
        seekAndAutoPlay(Double(endSlider.value))
    }

    @objc private func tapSave() {
        let start = CMTime(seconds: Double(startSlider.value), preferredTimescale: 600)
        let end   = CMTime(seconds: Double(endSlider.value), preferredTimescale: 600)
        trimPassthrough(url: url, start: start, end: end) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let outURL):
                self.dismiss(animated: true) { self.onComplete(outURL) }
            case .failure(let error):
                let alert = UIAlertController(title: "트리밍 실패", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    @objc private func tapCancel() {
        dismiss(animated: true) { self.onComplete(nil) }
    }

    private func updateLabels() {
        startLabel.text = "Start: " + format(Double(startSlider.value))
        endLabel.text   = "End: " + format(Double(endSlider.value))
    }

    private func format(_ seconds: Double) -> String {
        let s = max(0, Int(seconds.rounded()))
        return String(format: "%02d:%02d", s/60, s%60)
        }

    // Passthrough export (무손실 4K 유지)
    private func trimPassthrough(url: URL, start: CMTime, end: CMTime, completion: @escaping (Result<URL, Error>) -> Void) {
        let asset = AVAsset(url: url)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            return completion(.failure(NSError(domain: "export", code: -1, userInfo: [NSLocalizedDescriptionKey: "Exporter 생성 실패"])))
        }
        exporter.timeRange = CMTimeRangeFromTimeToTime(start: start, end: end)

        let outDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outURL = outDir.appendingPathComponent("trim-\(UUID().uuidString).mov")

        if exporter.supportedFileTypes.contains(.mov) {
            exporter.outputFileType = .mov
        } else if let first = exporter.supportedFileTypes.first {
            exporter.outputFileType = first
        }

        if FileManager.default.fileExists(atPath: outURL.path) {
            try? FileManager.default.removeItem(at: outURL)
        }
        exporter.outputURL = outURL

        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                switch exporter.status {
                case .completed: completion(.success(outURL))
                case .failed, .cancelled:
                    completion(.failure(exporter.error ?? NSError(domain: "export", code: -2, userInfo: [NSLocalizedDescriptionKey: "내보내기 실패"])))
                default: break
                }
            }
        }
    }
    
    // 1) 헬퍼 (seek 완료 후 자동 재생)
    private func seekAndAutoPlay(_ seconds: Double) {
        let t = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: t, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.player.play()
        }
    }
 
    
    
}
