//
//  ResultViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import UIKit

final class ResultViewController: UIViewController {
    
    // MARK: - Properties
     private let scrollView: UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.showsVerticalScrollIndicator = false
         return scrollView
     }()
     
     private let contentView: UIView = {
         let view = UIView()
         return view
     }()
     
     private let dateLabel: UILabel = {
         let label = UILabel()
         label.text = "2025년 04월 01일 (화)"
         label.font = .systemFont(ofSize: 28, weight: .bold)
         return label
     }()
     
     private let climbingModeView: UIView = {
         let view = UIView()
         view.backgroundColor = .systemGray6
         view.layer.cornerRadius = 15
         return view
     }()
     
     private let climbingModeLabel: UILabel = {
         let label = UILabel()
         label.text = "비숍 클라이밍"
         label.font = .systemFont(ofSize: 18)
         return label
     }()
     
     private let climbingModeArrow: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(systemName: "chevron.right")
         imageView.tintColor = .gray
         return imageView
     }()
     
     private let statisticsLabel: UILabel = {
         let label = UILabel()
         label.text = "통계"
         label.font = .systemFont(ofSize: 22, weight: .bold)
         return label
     }()
     
     // 통계 지표 컨테이너
     private let statsContainerView: UIView = {
         let view = UIView()
         return view
     }()
     
     // 상단 통계 영역 - 2x2 그리드
     private let attemptView = StatView(title: "시도", value: "9")
     private let completionView = StatView(title: "성공", value: "7")
     private let rateView = StatView(title: "완등률", value: "78%")
     private let maxLevelView = StatView(title: "최고난이도", value: "V5")
     
     private let exerciseTimeLabel: UILabel = {
         let label = UILabel()
         label.text = "운동 시간"
         label.font = .systemFont(ofSize: 16)
         label.textColor = .gray
         label.textAlignment = .center
         return label
     }()
     
     private let exerciseTimeValue: UILabel = {
         let label = UILabel()
         label.text = "5시간 49분"
         label.font = .systemFont(ofSize: 32, weight: .bold)
         label.textAlignment = .center
         return label
     }()
     
     private let problemsLabel: UILabel = {
         let label = UILabel()
         label.text = "문제"
         label.font = .systemFont(ofSize: 18, weight: .bold)
         return label
     }()
     
     private let problemsStackView: UIStackView = {
         let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.spacing = 15
         stackView.distribution = .fillEqually
         return stackView
     }()
     
     // MARK: - Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         setupViews()
         setupConstraints()
         setupProblems()
     }
     
     // MARK: - Setup
     private func setupViews() {
         view.backgroundColor = .white
         title = "클라이밍 기록"
         
         view.addSubview(scrollView)
         scrollView.addSubview(contentView)
         
         contentView.addSubview(dateLabel)
         contentView.addSubview(climbingModeView)
         climbingModeView.addSubview(climbingModeLabel)
         climbingModeView.addSubview(climbingModeArrow)
         
         contentView.addSubview(statisticsLabel)
         
         // 통계 영역 설정
         contentView.addSubview(statsContainerView)
         statsContainerView.addSubview(attemptView)
         statsContainerView.addSubview(completionView)
         statsContainerView.addSubview(rateView)
         statsContainerView.addSubview(maxLevelView)
         
         contentView.addSubview(exerciseTimeLabel)
         contentView.addSubview(exerciseTimeValue)
         
         contentView.addSubview(problemsLabel)
         contentView.addSubview(problemsStackView)
     }
     
     private func setupConstraints() {
         scrollView.snp.makeConstraints { make in
             make.edges.equalTo(view.safeAreaLayoutGuide)
         }
         
         contentView.snp.makeConstraints { make in
             make.edges.equalTo(scrollView)
             make.width.equalTo(scrollView)
         }
         
         dateLabel.snp.makeConstraints { make in
             make.top.equalTo(contentView).offset(20)
             make.leading.equalTo(contentView).offset(20)
             make.trailing.equalTo(contentView).offset(-20)
         }
         
         climbingModeView.snp.makeConstraints { make in
             make.top.equalTo(dateLabel.snp.bottom).offset(20)
             make.leading.equalToSuperview().offset(20)
             make.trailing.equalToSuperview().offset(-20)
             make.height.equalTo(60)
         }
         
         climbingModeLabel.snp.makeConstraints { make in
             make.centerY.equalTo(climbingModeView)
             make.leading.equalTo(climbingModeView).offset(20)
         }
         
         climbingModeArrow.snp.makeConstraints { make in
             make.centerY.equalTo(climbingModeView)
             make.trailing.equalTo(climbingModeView).offset(-20)
             make.width.height.equalTo(16)
         }
         
         statisticsLabel.snp.makeConstraints { make in
             make.top.equalTo(climbingModeView.snp.bottom).offset(30)
             make.leading.equalToSuperview().offset(20)
         }
         
         // 통계 컨테이너 레이아웃
         statsContainerView.snp.makeConstraints { make in
             make.top.equalTo(statisticsLabel.snp.bottom).offset(20)
             make.leading.equalToSuperview().offset(20)
             make.trailing.equalToSuperview().offset(-20)
             make.height.equalTo(130)
         }
         
         // 2x2 그리드로 통계 지표 배치
         let halfWidth = UIScreen.main.bounds.width / 2 - 30
         
         attemptView.snp.makeConstraints { make in
             make.top.leading.equalTo(statsContainerView)
             make.width.equalTo(halfWidth)
             make.height.equalTo(60)
         }
         
         completionView.snp.makeConstraints { make in
             make.top.equalTo(statsContainerView)
             make.trailing.equalTo(statsContainerView)
             make.width.equalTo(halfWidth)
             make.height.equalTo(60)
         }
         
         rateView.snp.makeConstraints { make in
             make.top.equalTo(attemptView.snp.bottom).offset(10)
             make.leading.equalTo(statsContainerView)
             make.width.equalTo(halfWidth)
             make.height.equalTo(60)
         }
         
         maxLevelView.snp.makeConstraints { make in
             make.top.equalTo(completionView.snp.bottom).offset(10)
             make.trailing.equalTo(statsContainerView)
             make.width.equalTo(halfWidth)
             make.height.equalTo(60)
         }
         
         exerciseTimeValue.snp.makeConstraints { make in
             make.top.equalTo(statsContainerView.snp.bottom).offset(30)
             make.centerX.equalToSuperview()
         }
         
         exerciseTimeLabel.snp.makeConstraints { make in
             make.bottom.equalTo(exerciseTimeValue.snp.top).offset(-5)
             make.centerX.equalToSuperview()
         }
         
         problemsLabel.snp.makeConstraints { make in
             make.top.equalTo(exerciseTimeValue.snp.bottom).offset(40)
             make.leading.equalToSuperview().offset(20)
         }
         
         problemsStackView.snp.makeConstraints { make in
             make.top.equalTo(problemsLabel.snp.bottom).offset(15)
             make.leading.equalToSuperview().offset(20)
             make.trailing.equalToSuperview().offset(-20)
             make.bottom.equalTo(contentView).offset(-30)
         }
     }
     
     private func setupProblems() {
         // 10개의 유사한 문제 아이템 생성
         for i in 1...10 {
             let problemView = createProblemView(number: i)
             problemsStackView.addArrangedSubview(problemView)
         }
     }
     
     private func createProblemView(number: Int) -> UIView {
         let containerView = UIView()
         containerView.backgroundColor = .clear
         
         // 원형 난이도 표시기
         let levelCircle = UIView()
         levelCircle.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
         levelCircle.layer.cornerRadius = 18
         
         let levelLabel = UILabel()
         levelLabel.text = "V\(number)"
         levelLabel.textColor = .white
         levelLabel.font = .systemFont(ofSize: 14, weight: .bold)
         levelLabel.textAlignment = .center
         
         levelCircle.addSubview(levelLabel)
         levelLabel.snp.makeConstraints { make in
             make.center.equalToSuperview()
         }
         
         // 향상된 프로그레스 바
         let progressView = UIProgressView(progressViewStyle: .default)
         progressView.progress = Float.random(in: 0.3...0.9) // 랜덤 진행률
         progressView.progressTintColor = UIColor(red: 0.92, green: 0.35, blue: 0.35, alpha: 1.0)
         progressView.trackTintColor = UIColor(red: 0.95, green: 0.75, blue: 0.75, alpha: 1.0)
         progressView.layer.cornerRadius = 6
         progressView.clipsToBounds = true
         progressView.transform = CGAffineTransform(scaleX: 1, y: 2) // 높이 조정
         
         // 진행률 텍스트
         let countLabel = UILabel()
         let attempts = Int.random(in: 1...5)
         let completions = Int.random(in: 0...attempts)
         countLabel.text = "\(completions) / \(attempts)"
         countLabel.font = .systemFont(ofSize: 14)
         countLabel.textAlignment = .right
         
         containerView.addSubview(levelCircle)
         containerView.addSubview(progressView)
         containerView.addSubview(countLabel)
         
         // 제약 조건 설정
         levelCircle.snp.makeConstraints { make in
             make.leading.centerY.equalToSuperview()
             make.width.height.equalTo(36)
         }
         
         progressView.snp.makeConstraints { make in
             make.leading.equalTo(levelCircle.snp.trailing).offset(15)
             make.centerY.equalToSuperview()
             make.trailing.equalTo(countLabel.snp.leading).offset(-15)
         }
         
         countLabel.snp.makeConstraints { make in
             make.trailing.centerY.equalToSuperview()
             make.width.equalTo(50)
         }
         
         containerView.snp.makeConstraints { make in
             make.height.equalTo(50)
         }
         
         return containerView
     }
 }

 // MARK: - Helper Views
 class StatView: UIView {
     private let valueLabel: UILabel = {
         let label = UILabel()
         label.font = .systemFont(ofSize: 24, weight: .bold)
         label.textAlignment = .center
         return label
     }()
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.font = .systemFont(ofSize: 14)
         label.textColor = .gray
         label.textAlignment = .center
         return label
     }()
     
     private let containerView: UIView = {
         let view = UIView()
         view.backgroundColor = .systemGray6
         view.layer.cornerRadius = 12
         return view
     }()
     
     init(title: String, value: String) {
         super.init(frame: .zero)
         
         valueLabel.text = value
         titleLabel.text = title
         
         addSubview(containerView)
         containerView.addSubview(valueLabel)
         containerView.addSubview(titleLabel)
         
         setupConstraints()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func setupConstraints() {
         containerView.snp.makeConstraints { make in
             make.edges.equalToSuperview()
         }
         
         valueLabel.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(8)
             make.centerX.equalToSuperview()
         }
         
         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(valueLabel.snp.bottom).offset(5)
             make.centerX.equalToSuperview()
             make.bottom.lessThanOrEqualToSuperview().offset(-8)
         }
     }
}

