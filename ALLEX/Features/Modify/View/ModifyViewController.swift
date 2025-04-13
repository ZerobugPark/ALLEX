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
    
    
    weak var coordinator: CalendarCoordinator?
    
    
    private let selectedGym = PublishRelay<(String, String)>()
    private let countType = PublishRelay<(CountType, String)>()
    
    typealias listDataSource = RxCollectionViewSectionedReloadDataSource<BoulderingSection>
    typealias collectionViewDataSource = CollectionViewSectionedDataSource<BoulderingSection>
    
    private let barButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    
    private lazy var dataSource: listDataSource = listDataSource (configureCell: { [weak self] dataSource, collectionView, indexPath, item in
        
        guard let self = self else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModifyCollectionViewCell.reuseId, for: indexPath) as? ModifyCollectionViewCell else { return UICollectionViewCell() }
    
        
        cell.setupData(item)
        
        cell.bouldering.successCountButton.minusButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.countType.accept((.successMinus, item.gradeLevel))
            
        }.disposed(by: cell.disposeBag)
        
        cell.bouldering.successCountButton.plusButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.countType.accept((.successPlus, item.gradeLevel))
            
        }.disposed(by: cell.disposeBag)
        
        cell.bouldering.tryCountButton.minusButton.rx.tap.bind(with: self) { owner, _ in
            owner.countType.accept((.tryMinus, item.gradeLevel))
            
        }.disposed(by: cell.disposeBag)
        
        cell.bouldering.tryCountButton.plusButton.rx.tap.bind(with: self) { owner, _ in
            owner.countType.accept((.tryPlus, item.gradeLevel))
            
        }.disposed(by: cell.disposeBag)
        
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
        registerCollectionView()
        
        navigationItem.rightBarButtonItem = barButtonItem
        
        mainView.spaceTextField.delegate = self
        mainView.timeTxetFiled.delegate = self
        
    }
    
    
    override func bind() {
        
        // 1. timePicker에서 duration을 Observable로 변경
        let timeSelected = mainView.timePicker.rx
            .controlEvent(.valueChanged)
            .map { [weak mainView] in mainView?.timePicker.countDownDuration ?? 0 }
        
        let dateText = mainView.dateTextField.rx.text.orEmpty
        let nameText = mainView.timeTxetFiled.rx.text.orEmpty
        let gradeText = mainView.spaceTextField.rx.text.orEmpty

        let inputFields = Observable.combineLatest(dateText, nameText, gradeText)
        
        
        
        let input = ModifyViewModel.Input(spaceTextField: mainView.spaceTextField.rx.text.orEmpty, doneButtonTapped: mainView.doneButton.rx.tap.withLatestFrom(timeSelected), selectedGym: selectedGym.asDriver(onErrorJustReturn: ("", "")), countType: countType.asDriver(onErrorJustReturn: (.successMinus, "")), saveButtonTapped: barButtonItem.rx.tap.withLatestFrom(inputFields))
        
        let output = viewModel.transform(input: input)
        
        output.gymList.drive(mainView.tableView.rx.items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)) { row, element , cell in
            
            cell.setupUI(data: element)
        }.disposed(by: disposeBag)
        
        output.dismiss.drive(with: self) { owner, _ in
            
            print(owner.coordinator)
            owner.coordinator?.dismiss()
            
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
        
        mainView.tableView.rx.modelSelected(Gym.self).bind(with: self) { owner, data in
            
            owner.selectedGym.accept((data.brandID, data.gymID))
            
            owner.mainView.spaceTextField.text = data.nameKo
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

extension ModifyViewController {
    
    private func registerCollectionView() {
        mainView.tableView.register(GymListTableViewCell.self, forCellReuseIdentifier: GymListTableViewCell.id)
        
        
        mainView.collectionView.register(
            ModifyCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ModifyCollectionReusableView.reuseId)
        
        
        mainView.collectionView.register(ModifyCollectionViewCell.self, forCellWithReuseIdentifier: ModifyCollectionViewCell.id)
        
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
}
