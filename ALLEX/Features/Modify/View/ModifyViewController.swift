//
//  ModifyViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/10/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources


final class ModifyViewController: BaseViewController<ModifyView, ModifyViewModel> {
    

    weak var coordinator: ModifyCoordinating?
    
    
    private let selectedGym = PublishRelay<(String, String)>()
    private let countType = PublishRelay<(CountType, Int)>()
    
    typealias listDataSource = RxCollectionViewSectionedReloadDataSource<BoulderingSection>
    typealias collectionViewDataSource = CollectionViewSectionedDataSource<BoulderingSection>
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    private lazy var dataSource: listDataSource = listDataSource (configureCell: { [weak self] dataSource, collectionView, indexPath, item in
        
        guard let self = self else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModifyCollectionViewCell.reuseId, for: indexPath) as? ModifyCollectionViewCell else { return UICollectionViewCell() }
    
        
        cell.setupData(item)
        
        let gradeLevel = item.gradeLevel
        
        bindCountButton(cell.bouldering.successCountButton.minusButton, countType: .successMinus, gradeLevel: gradeLevel, disposeBag: cell.disposeBag)
        
        bindCountButton(cell.bouldering.successCountButton.plusButton, countType: .successPlus, gradeLevel: gradeLevel, disposeBag: cell.disposeBag)
        
        bindCountButton(cell.bouldering.tryCountButton.minusButton, countType: .tryMinus, gradeLevel: gradeLevel, disposeBag: cell.disposeBag)
        
        bindCountButton(cell.bouldering.tryCountButton.plusButton, countType: .tryPlus, gradeLevel: gradeLevel, disposeBag: cell.disposeBag)
        
    
        return cell
        
    },      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ModifyCollectionReusableView.reuseId, for: indexPath) as? ModifyCollectionReusableView else {
             return UICollectionReusableView()
         }
         
   
         let section = dataSource[indexPath.section]
            
         return header
        
    })
                                                                  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        setupTextFieldDelegates()
    }
    
    
    override func bind() {
        
        // 1. timePicker에서 duration을 Observable로 변경
        let timeSelected = mainView.timePicker.rx
            .controlEvent(.valueChanged)
            .map { [weak mainView] in mainView?.timePicker.countDownDuration ?? 0 }
     

        let inputFields = Observable
             .combineLatest(
                 mainView.dateTextField.rx.text.orEmpty,
                 mainView.timeTxetFiled.rx.text.orEmpty,
                 mainView.spaceTextField.rx.text.orEmpty
             )
        
        
        let input = ModifyViewModel.Input(
            viewDidLoadTrigger: Observable.just(()),
            spaceTextField: mainView.spaceTextField.rx.text.orEmpty,
            doneButtonTapped: mainView.doneButton.rx.tap.withLatestFrom(timeSelected),
            selectedGym: selectedGym.asDriver(onErrorJustReturn: ("", "")),
            countType: countType.asDriver(onErrorJustReturn: (.successMinus, 0)),
            saveButtonTapped: saveButton.rx.tap.withLatestFrom(inputFields)
        )
        
        let output = viewModel.transform(input: input)
        
        output.gymList.drive(
            mainView.tableView.rx
                .items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)
        ) { row, element , cell in
            
            cell.setupUI(data: element)
            
        }.disposed(by: disposeBag)
        
        output.popView.drive(with: self) { owner, _ in
            
            owner.coordinator?.popView()
            
        }.disposed(by: disposeBag)
        
        
        output.timeTextField.drive(with: self) { owner, time in
            owner.mainView.timeTxetFiled.text = time
            owner.mainView.timeTxetFiled.resignFirstResponder()
            
        }.disposed(by: disposeBag)
         
        
        output.bouldering.drive(mainView.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
   
        output.errorMessage.drive(with: self) { owner, _ in
            
            let alert = UIAlertController(title: "입력 오류", message: "모든 항목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            owner.present(alert, animated: true)
            
        }.disposed(by: disposeBag)
        
        
        output.modifyInit.drive(with: self) { owner, value in
            owner.mainView.timeTxetFiled.text = value.time
            owner.mainView.spaceTextField.text = value.space
            owner.mainView.dateTextField.text = value.date
        
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Gym.self).bind(with: self) { owner, data in
            owner.selectedGym.accept((data.brandID, data.gymID))
          
            owner.mainView.spaceTextField.text = Locale.isEnglish ? data.nameEn : data.nameKo
            owner.mainView.spaceTextField.resignFirstResponder()
            
        }.disposed(by: disposeBag)
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension ModifyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false // 입력 차단
    }
}

extension ModifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: view.frame.width, height: 70)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
}

private extension ModifyViewController {
    
    func setupNavigation() {
        navigationItem.rightBarButtonItem = saveButton
    }

    func setupTextFieldDelegates() {
        mainView.spaceTextField.delegate = self
        mainView.timeTxetFiled.delegate = self
    }
    
    func setupCollectionView() {
        mainView.tableView.register(GymListTableViewCell.self, forCellReuseIdentifier: GymListTableViewCell.id)
        
        mainView.collectionView.register(ModifyCollectionViewCell.self, forCellWithReuseIdentifier: ModifyCollectionViewCell.id)
        mainView.collectionView.register(ModifyCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ModifyCollectionReusableView.reuseId)
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
        
    
    // MARK: DRY원칙 적용 (Don't Repeat Yourself)
    // 1. 동일한 로직을 사용하는 대신에, 함수로 묶어서 하나의 메서드로 처리
    private func bindCountButton(_ button: UIButton, countType: CountType, gradeLevel: Int, disposeBag: DisposeBag) {
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.countType.accept((countType, gradeLevel))
            }
            .disposed(by: disposeBag)
    }
    
}
