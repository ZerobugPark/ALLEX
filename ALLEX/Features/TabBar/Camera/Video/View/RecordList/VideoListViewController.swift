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
    
    private var recordedVideos: [Int: [URL]]
    private let tableView = UITableView()
    
    private var sectionKeys: [Int] = []
    
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
            let videoURL = self.url(at: indexPath)
            
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
    

}

