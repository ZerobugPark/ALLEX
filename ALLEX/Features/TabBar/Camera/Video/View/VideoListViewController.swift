//
//  VideoListViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit
import AVKit

import SnapKit
import Photos


class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var videoURLs: [URL]
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            let removedURL = self.videoURLs.remove(at: indexPath.row)
            do {
                try FileManager.default.removeItem(at: removedURL)
                print("파일 삭제됨: \(removedURL)")
            } catch {
                print("파일 삭제 오류: \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let saveAction = UIContextualAction(style: .normal, title: "저장") { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            let videoURL = self.videoURLs[indexPath.row]
            self.saveVideoToGallery(videoURL: videoURL) { success in
                completion(success)
            }
        }
        saveAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, saveAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func saveVideoToGallery(videoURL: URL, completion: @escaping (Bool) -> Void) {
        guard FileManager.default.fileExists(atPath: videoURL.path) else {
            print("파일이 존재하지 않음: \(videoURL)")
            DispatchQueue.main.async {
                self.showAlert(title: "오류", message: "저장할 동영상 파일을 찾을 수 없습니다.")
            }
            completion(false)
            return
        }
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            saveToLibrary(videoURL: videoURL, completion: completion)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.saveToLibrary(videoURL: videoURL, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "권한 필요", message: "설정에서 사진 접근 권한을 허용해주세요.")
                    }
                    completion(false)
                }
            }
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showAlert(title: "권한 필요", message: "설정에서 사진 접근 권한을 허용해주세요.")
            }
            completion(false)
            
        default:
            completion(false)
        }
    }
    
    private func saveToLibrary(videoURL: URL, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            // throw 제거, nil 체크로 대체
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            if request == nil {
                print("PHAssetChangeRequest 생성 실패")
            } else {
                print("갤러리 저장 요청: \(videoURL)")
            }
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("갤러리에 저장됨: \(videoURL)")
                    completion(true)
                } else {
                    let errorMessage = error?.localizedDescription ?? "알 수 없는 오류"
                    print("갤러리 저장 오류: \(errorMessage)")
                    self.showAlert(title: "저장 실패", message: "갤러리에 저장하지 못했습니다: \(errorMessage)")
                    completion(false)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
