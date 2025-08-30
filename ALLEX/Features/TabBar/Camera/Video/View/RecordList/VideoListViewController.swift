//
//  VideoListViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit
import AVKit
import AVFoundation
import Photos

import SnapKit



final class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIVideoEditorControllerDelegate, UINavigationControllerDelegate {
    
    private var recordedVideos: [Int: [URL]]
    private let tableView = UITableView()
    
    private var sectionKeys: [Int] = []
    private var editingIndexPath: IndexPath?
    
    var resultData: (([Int: [URL]]) -> Void)
    
    init(recordedVideos: [Int: [URL]], resultData: @escaping (([Int: [URL]]) -> Void)) {
        self.recordedVideos = recordedVideos
        self.sectionKeys = recordedVideos.keys.sorted()
        self.resultData = resultData
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultData(recordedVideos)
    }
    

}

extension VideoListViewController {
    
    private func url(at indexPath: IndexPath) -> URL {
        let key = sectionKeys[indexPath.section]
        return recordedVideos[key]![indexPath.row]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionKeys.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionKeys[section]
        return recordedVideos[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoThumbnailCell", for: indexPath) as! VideoThumbnailCell
        let videoURL = url(at: indexPath)
        cell.configure(with: videoURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = url(at: indexPath)
        let player = AVPlayer(url: videoURL)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            player.play()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { completion(false); return }

            let key = self.sectionKeys[indexPath.section]
            guard var urls = self.recordedVideos[key] else { completion(false); return }

            let removedURL = urls.remove(at: indexPath.row)
            self.recordedVideos[key] = urls

            do {
                try FileManager.default.removeItem(at: removedURL)
                print("파일 삭제됨: \(removedURL)")
            } catch {
                print("파일 삭제 오류: \(error)")
            }
            
            if urls.isEmpty {
                self.recordedVideos.removeValue(forKey: key)
                self.sectionKeys.removeAll { $0 == key }
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "편집") { [weak self] (action, view, completion) in
            guard let self = self else { completion(false); return }
            let url = self.url(at: indexPath)
            self.presentPassthroughTrimPrompt(for: url, at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = sectionKeys[section]
        return "Grade \(key)"
    }
    
    private func presentEditor(for url: URL, at indexPath: IndexPath) {
        let path = url.path
        guard UIVideoEditorController.canEditVideo(atPath: path) else {
            showAlert(title: "편집 불가", message: "이 동영상은 편집할 수 없는 형식이거나 경로입니다.")
            return
        }
        editingIndexPath = indexPath
        let editor = UIVideoEditorController()
        editor.videoPath = path
        editor.videoQuality = .typeHigh
        editor.delegate = self
        
        present(editor, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    

}

extension VideoListViewController {
    // MARK: - Passthrough Trim UI (시작/끝 초 입력받기)
    private func presentPassthroughTrimPrompt(for url: URL, at indexPath: IndexPath) {
        let trimmer = PassthroughTrimViewController(url: url) { [weak self] outURL in
            guard let self = self else { return }
            guard let outURL else { return } // 사용자가 취소한 경우
            let key = self.sectionKeys[indexPath.section]
            guard var urls = self.recordedVideos[key] else { return }
            let oldURL = urls[indexPath.row]
            urls[indexPath.row] = outURL
            self.recordedVideos[key] = urls
            try? FileManager.default.removeItem(at: oldURL) // 원본 유지 원하면 이 줄을 제거
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        present(trimmer, animated: true)
    }

    // MARK: - Passthrough 트리밍 (재인코딩 없음, 4K 유지)
    private func trimPassthrough(url: URL,
                                 start: CMTime,
                                 end: CMTime,
                                 completion: @escaping (Result<URL, Error>) -> Void) {
        let asset = AVAsset(url: url)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completion(.failure(NSError(domain: "export", code: -1, userInfo: [NSLocalizedDescriptionKey: "Exporter 생성 실패"])))
            return
        }
        exporter.timeRange = CMTimeRangeFromTimeToTime(start: start, end: end)

        let outDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outURL = outDir.appendingPathComponent("trim-\(UUID().uuidString).mov")

        // 파일타입 설정 (지원 목록 중 선택)
        let types = exporter.supportedFileTypes
        if types.contains(.mov) {
            exporter.outputFileType = .mov
        } else if let first = types.first {
            exporter.outputFileType = first
        } else {
            completion(.failure(NSError(domain: "export", code: -2, userInfo: [NSLocalizedDescriptionKey: "지원 파일 타입 없음"])))
            return
        }

        // 기존 경로가 있으면 제거
        if FileManager.default.fileExists(atPath: outURL.path) {
            try? FileManager.default.removeItem(at: outURL)
        }
        exporter.outputURL = outURL

        // 무거운 작업이므로 비동기
        exporter.exportAsynchronously { [weak exporter] in
            DispatchQueue.main.async {
                guard let exporter else { return }
                switch exporter.status {
                case .completed:
                    completion(.success(outURL))
                case .failed, .cancelled:
                    completion(.failure(exporter.error ?? NSError(domain: "export", code: -3, userInfo: [NSLocalizedDescriptionKey: "내보내기 실패"])))
                default:
                    break
                }
            }
        }
    }
}

