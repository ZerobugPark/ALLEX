//
//  VideoCaptureView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit
import AVFoundation
import SnapKit

final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

final class VideoCaptureView: BaseView {
    
    
    // MARK: - UI 요소
    let previewView = CameraPreviewView()
    
    let recordButton = RecordButton()
    
    let folderButton = UIButton()
    
    private let settingsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let qualityButton = UIButton()
    
    let aspectRatioButton = UIButton()
    
    let closeButton = UIButton()
    
    lazy var gradeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    let gradeButton = UIButton()
    
    // MARK: - Aspect Ratio Overlay
    private let overlayMaskLayer = CAShapeLayer()
    private let cropBorderLayer = CAShapeLayer()
    var aspectRatio: VideoAspectRatio = .ratio9x16 { // default portrait
        didSet { updateAspectOverlay() }
    }
    
    
    override func configureHierarchy() {
        self.addSubviews(previewView, settingsView, containerView, gradeCollectionView)
        settingsView.addSubviews(closeButton, aspectRatioButton, qualityButton)
        containerView.addSubviews(folderButton, recordButton, gradeButton)
   
    }
    
    override func configureLayout() {
        // MARK: - UI 설정
        
        settingsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(20)
        }
        
        
        aspectRatioButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        
        
        qualityButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(20)
        }
        
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }

        
        folderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        gradeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        gradeCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(160)
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
        }
        
    }
    
    override func configureView() {

        folderButton.setImage(UIImage(systemName: "folder"), for: .normal)
        folderButton.tintColor = .white
        folderButton.isHidden = true
        
        
        folderButton.contentHorizontalAlignment = .fill
        folderButton.contentVerticalAlignment = .fill
        folderButton.imageView?.contentMode = .scaleAspectFit
        folderButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        // Increase the symbol point size; without this, SFSymbols default to ~17pt and look small
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        folderButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        
        gradeButton.setTitle("난이도", for: .normal)
        gradeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        gradeButton.setTitleColor(.setAllexColor(.backGround), for: .normal)

    
        
        closeButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        closeButton.tintColor = .setAllexColor(.backGround)
        
        aspectRatioButton.setTitle("9:16", for: .normal)
        aspectRatioButton.setTitleColor(.setAllexColor(.backGround), for: .normal)
        
        qualityButton.setTitle("HD", for: .normal)
        qualityButton.setTitleColor(.setAllexColor(.backGround), for: .normal)
        
        previewView.isOpaque = true
        previewView.layer.masksToBounds = true
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill

        // Overlay setup (dim outside crop area)
        overlayMaskLayer.fillRule = .evenOdd
        overlayMaskLayer.fillColor = UIColor.black.withAlphaComponent(0.45).cgColor
        overlayMaskLayer.frame = previewView.bounds
        previewView.layer.addSublayer(overlayMaskLayer)

        // Visible crop border
        cropBorderLayer.fillColor = UIColor.clear.cgColor
        cropBorderLayer.lineWidth = 2
        cropBorderLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        previewView.layer.addSublayer(cropBorderLayer)
        cropBorderLayer.isHidden = true

        // Initial overlay draw
        updateAspectOverlay()
        
        previewView.backgroundColor = .black

        gradeCollectionView.showsVerticalScrollIndicator = false
        gradeCollectionView.showsHorizontalScrollIndicator = false
        
        gradeCollectionView.isHidden = true
    }
    
    
    /// 외부에서 비율 변경 시 호출 (VC에서 mainView.aspectRatio = ... 로 사용)
    func setAspectRatio(_ ratio: VideoAspectRatio) {
        self.aspectRatio = ratio
    }

    /// 프리뷰 위에 선택된 비율(9:16, 4:5)의 안전 영역을 시각적으로 표시
    private func updateAspectOverlay() {
        let bounds = previewView.bounds
        guard bounds.width > 0 && bounds.height > 0 else { return }

        let target: CGSize
        switch aspectRatio {
        case .ratio9x16:
            target = CGSize(width: 9, height: 16)
        case .ratio4x5:
            target = CGSize(width: 4, height: 5)
        }

        // 프리뷰 bounds 안에서 비율 유지한 안전 영역 계산 (센터 기준)
        // 영상이 촬영되는 크기의 영역
        let safeRect = AVMakeRect(aspectRatio: target, insideRect: bounds)

        /// 전체 크기의 마스크 (데이터 경로)
        let maskPath = UIBezierPath(rect: bounds)
        /// 마스크 안에 촬영 영역 처리
        maskPath.append(UIBezierPath(rect: safeRect))
        
        /// 마스크를 쓸 뷰의 크기는 전체 크기
        overlayMaskLayer.frame = bounds
        
        /// 어떤 점이 패스에 의해 홀수 번 포함되면 채우고, 짝수 번 포함되면 비운다. (MaskPath 기준)
        /// bounds 바깥 → 포함 0번(짝수) → 비움
        /// bounds 안 & safeRect 바깥 → bounds에 1번 포함(홀수) → 채움 (검정)
        /// safeRect 안쪽 → bounds(1) + safeRect(1) = 2번(짝수) → 비움 (뚫림)
        /// overlayMaskLayer.path = maskPath.cgPath 아 그러면 여기서 지금 path 기준으로 짝수인 전체 bouns 즉 overlayMaskLAyer 는 채우고, safeRect영역 만큼만 이제 뺌
        overlayMaskLayer.fillRule = .evenOdd // 홀수만 채우겠다.
        
        /// 마스크할 패스 설정
        overlayMaskLayer.path = maskPath.cgPath
        overlayMaskLayer.fillColor = UIColor.black.cgColor

        
        aspectRatioButton.setTitle(aspectRatio.title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 미리보기 레이어 프레임 갱신
        if previewView.layer.sublayers?.contains(previewView.videoPreviewLayer) == true {
            previewView.videoPreviewLayer.frame = previewView.bounds
        }
        gradeCollectionView.layer.cornerRadius = 10
        updateAspectOverlay()
        updateGradeLayout()
    }
    
    // 5 items per row, up to 2 rows (height = 80)
    private func updateGradeLayout() {
        guard let layout = gradeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let columns: CGFloat = 5
        //// We want exact 2 rows in 80pt, so line spacing must be 0 and item height = 40
        layout.minimumLineSpacing = 20

        // Keep circle diameter 40pt
        let itemSide: CGFloat = 60
        layout.itemSize = CGSize(width: itemSide, height: itemSide)
        
        
        // Compute horizontal spacing so exactly 5 items fit the current width
        let availableWidth = gradeCollectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let rawSpacing = (availableWidth - (columns * itemSide)) / (columns - 1)
        layout.minimumInteritemSpacing = max(0, floor(rawSpacing))

        layout.invalidateLayout()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }
    
}
