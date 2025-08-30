//
//  VideoThumbnailCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit
import AVKit

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
            make.width.equalTo(100)
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
