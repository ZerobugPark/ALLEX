//
//  VideoCaptureViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import Foundation

import RxSwift
import RxCocoa
import AVFoundation
import Photos


final class VideoCaptureViewModel: BaseViewModel {
    
    struct Input {
        let selectedGrade: Driver<BoulderingAttempt>
        let savedVideo: Driver<(URL, VideoAspectRatio)>
        let editVideo: Driver<[Int : [URL]]>
        let recordedButton: ControlEvent<Void>
        let savedRecord: Driver<Void>
    }
    
    struct Output {
        let gymGrade: Driver<[BoulderingAttempt]>
        let currentColor: Driver<String>
        let finisehdVideo: Driver<Void>
        let dismissView: Driver<Void>
    }
    
    var disposeBag =  DisposeBag()
    
    private var gymGradeList: [BoulderingAttempt] = []
    private(set) var color = "white"
    
    private(set) var recordedVideos: [Int: [URL]] = [:]
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    private let spaceRepo: any ClimbingSpaceRepository = RealmClimbingSpaceRepository()
    private var timeCount = 0
    private let timerQueue = DispatchQueue(label: "allex.video.timer.queue", qos: .background)
    private var timer: DispatchSourceTimer?
    
    
    init() {
        getGymInfo()
        startTimer()
    }
    
    
    func transform(input: Input) -> Output {
        
        let gymGrade = BehaviorRelay(value: gymGradeList)
        let currentColor = BehaviorRelay(value: color)
        let finisehdVideo = BehaviorRelay(value: ())
        let dismissView = PublishRelay<Void>()
        
        input.selectedGrade.drive(with: self) { owner, value in
            owner.color = value.color
            currentColor.accept(owner.color)
        }.disposed(by: disposeBag)
        
        
        input.savedVideo.drive(with: self) { owner, value in
            
            // iOS 16+ 기준: 비동기 처리로 후보정 후 저장
            Task { [weak owner] in
                await owner?.processAndSaveVideoAsync(originalURL: value.0, ratio: value.1)
                finisehdVideo.accept(())
            }
            
            
            
        }.disposed(by: disposeBag)
        
        input.recordedButton.bind(with: self) { owner, _ in
            
            if let index = owner.gymGradeList.firstIndex(where: { $0.color == owner.color }) {
                owner.gymGradeList[index].tryCount += 1
            }
            
        }.disposed(by: disposeBag)
        
        input.editVideo.drive(with: self) { owner, value in
            
            for (key, value) in value {
                owner.gymGradeList[key].successCount = value.count
            }
            
            owner.recordedVideos = value
        }.disposed(by: disposeBag)
        
        input.savedRecord.drive(with: self) { owner, _ in
            
            for (key, value) in owner.recordedVideos {
                owner.gymGradeList[key].successCount = value.count
            }
            
            owner.savedData()
            dismissView.accept(())
            
        }.disposed(by: disposeBag)
        
        return Output(
            gymGrade: gymGrade.asDriver(onErrorJustReturn: []),
            currentColor: currentColor.asDriver(onErrorJustReturn: ""),
            finisehdVideo: finisehdVideo.asDriver(onErrorJustReturn: ()),
            dismissView: dismissView.asDriver(onErrorJustReturn: ())
        )
    }
    
    private func startTimer() {
        let t = DispatchSource.makeTimerSource(queue: timerQueue)
        t.schedule(deadline: .now() + 1, repeating: 1.0)
        t.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.timeCount += 1
        }
        timer = t
        t.resume()
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    
    
    deinit {
        stopTimer()
        print("\(type(of: self)) Deinit")
    }
    
}


extension VideoCaptureViewModel {
    private func getGymInfo() {
        
        let info = UserDefaultManager.selectedClimb

        
        guard let gradeInfo = try? spaceRepo.fetchBouldering(brandID: info[0]) else { return }
    
        color = gradeInfo.first!.color
  
        gymGradeList.append(contentsOf: gradeInfo.map {
            BoulderingAttempt(gradeLevel: Int($0.gradeLevel) ?? 0, color: $0.color, difficulty: $0.difficulty, tryCount: 0, successCount: 0)
        })
        
    }
    
    func savedData() {
        // 1. 필요한 데이터 준비
        let info =  UserDefaultManager.selectedClimb
        let brandId = info[0]
        let gymId = info[1]
        let timeMinute = max(1, timeCount / 60)
        let currentDate = Date()
        
        // 2. 통계 계산 (한 번의 순회로 여러 값 계산)
        var totalClimbCount = 0
        var totalSuccessCount = 0
        let bestGrade = gymGradeList
            .filter { grade in
                // 시도 및 성공 횟수 계산
                if grade.tryCount > 0 {
                    totalClimbCount += grade.tryCount
                }
                if grade.successCount > 0 {
                    totalSuccessCount += grade.successCount
                    return true  // 성공한 항목만 반환
                }
                return false
            }
            .max(by: { $0.gradeLevel < $1.gradeLevel })
        
        let bestGradeDifficulty = bestGrade?.difficulty ?? "VB"
        
        // 3. 결과 데이터 변환
        let routeResults = gymGradeList.map { element in
            RouteResult(
                level: element.gradeLevel,
                color: element.color,
                difficulty: element.difficulty,
                totalClimbCount: element.tryCount,
                totalSuccessCount: element.successCount
            )
        }
        
        // 4. 데이터 저장
        let boulderingList = BoulderingList(
            brandId: brandId,
            gymId: gymId,
            climbTime: timeMinute,
            climbDate: currentDate,
            bestGrade: bestGradeDifficulty,
            routeResults: routeResults
        )
        
        for (_, value) in recordedVideos {
            for url in value {
                saveToGallery(videoURL: url)
            }
        }
        
        repository.createMonthlyClimbingResult(boulderingList: boulderingList, date: currentDate)
        
    }

    
    
}

extension VideoCaptureViewModel {
    /// iOS 16+ 전제: 비디오를 선택된 비율로 센터 크롭/리사이즈 후 저장
    private func processAndSaveVideoAsync(originalURL: URL, ratio: VideoAspectRatio) async {
        
        /// 원본인 경우 그냥 저장
        if ratio == .ratio9x16 {
            append(url: originalURL, color: color)
            return
        }

        let asset = AVAsset(url: originalURL)

        // 1) 메타 로딩 (iOS 16+ async APIs)
        let assetDuration = (try? await asset.load(.duration)) ?? .zero
        let videoTrack = try? await asset.loadTracks(withMediaType: .video).first
        guard let videoTrack else {
            print("비디오 트랙을 찾을 수 없습니다")
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
            return
        }
        do {
            try compVideo.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: videoTrack, at: .zero)
            compVideo.preferredTransform = .identity
        } catch {
            print("비디오 트랙 삽입 실패: \(error)")
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
            self.append(url: outURL, color: color)
        case .failed, .cancelled:
            print("Export 실패: \(exporter.error?.localizedDescription ?? "unknown") — 원본 저장 시도")
            self.append(url: outURL, color: color)
        default:
            break
        }
    }

    
    private func append(url: URL, color: String) {
        
        if let index = gymGradeList.firstIndex(where: { $0.color == color }) {
            recordedVideos[index, default: []].append(url)
        }
        
    }
    
    private func saveToGallery(videoURL: URL) {
        guard FileManager.default.fileExists(atPath: videoURL.path) else {
            print("파일이 존재하지 않음: \(videoURL)")
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else {
                print("사진 앱에 추가 권한이 없습니다: \(status)")
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                if let error = error {
                    print("갤러리 저장 오류: \(error)")
                } else {
                    print("갤러리에 저장됨: \(success) — \(videoURL)")
                }
            }
        }
    }
}
