//
//  GymSelectionViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

final class GymSelectionViewController: BaseViewController<GymSelectionView, GymSelectionViewModel> {

    var coordinator :GymSelectionCoordinator?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showGymList))
        mainView.spaceLabel.addGestureRecognizer(tapGesture)
        


    }
    
    override func bind() {
        
        let input = GymSelectionViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.updateGym.drive(with: self) { owner, str in
            owner.mainView.spaceLabel.text = str
            owner.mainView.startButton.isEnabled = true
        }.disposed(by: disposeBag)
        
        mainView.startButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.didSelectGym()
            
        }.disposed(by: disposeBag)
        
    }
    
    @objc private func showGymList() {
        coordinator?.showGymlist()
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }

}
