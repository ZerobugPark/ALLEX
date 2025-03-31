//
//  GymListViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import Foundation

import RxSwift
import RxCocoa

final class GymListViewModel: BaseViewModel {
    
    var sharedData: SharedDataModel
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchText: Observable<ControlProperty<String>.Element>
        let selectedGym : Driver<String>
    }
    
    struct Output {
        let list: Driver<[Gym]>
        let dismiss: Driver<Void>
    }
    
    var disposeBag =  DisposeBag()
    private var gymList: [Gym] = []
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.gymList = sharedData.getData(for: Gym.self)!
    }
    
    
    func transform(input: Input) -> Output {
        
        let list = BehaviorRelay(value: gymList)
        let dismiss = PublishRelay<Void>()
        
        input.viewDidLoad.bind(with: self) { owner, _ in
            
            list.accept(owner.gymList)
            
        }.disposed(by: disposeBag)
        
        input.searchText.bind(with: self) { owner, text in
            
            
            if text.isEmpty {
                owner.gymList = owner.sharedData.getData(for: Gym.self)!
            } else {
                owner.gymList = owner.filterArray(str: text)
            }
            
            list.accept(owner.gymList)
        }.disposed(by: disposeBag)
        
        input.selectedGym.drive(with: self) { owner, value in
            owner.sharedData.userSelectedGymID = value
            
            NotificationCenterManager.isSelected.post()
            
            dismiss.accept(())
        }.disposed(by: disposeBag)
    
        return Output(list: list.asDriver(onErrorJustReturn: []), dismiss: dismiss.asDriver(onErrorJustReturn: ()))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}

extension GymListViewModel {
    
    private func filterArray(str: String) -> [Gym] {
    
        let normalizedStr = str.replacingOccurrences(of: " ", with: "").uppercased()
        
        if detectLanguage(text: normalizedStr) == "Korean" {
            let data = sharedData.getData(for: Gym.self)!.filter { gym in
                let normalizedNameKo = gym.nameKo.replacingOccurrences(of: " ", with: "").uppercased()
                
                // contains시 공백제거 해놓고 비교해야 할듯, 안하니까 띄어쓰기 문자열이랑 비교연산이 안됨.
                return normalizedNameKo.contains(normalizedStr)
            }
            return data
        } else if  detectLanguage(text: normalizedStr) == "English" {
            let data = sharedData.getData(for: Gym.self)!.filter { gym in
                let normalizedNameEn = gym.nameEn.replacingOccurrences(of: " ", with: "").uppercased()
                return normalizedNameEn.contains(normalizedStr)
            }
            return data
        } else {
            return []
        }
    }
    
    private func detectLanguage(text: String) -> String {
        let koreanRegex = "^[가-힣ㄱ-ㅎㅏ-ㅣ]+$"
        let englishRegex = "^[a-zA-Z]+$"

        if text.range(of: koreanRegex, options: .regularExpression) != nil {
            return "Korean"
        } else if text.range(of: englishRegex, options: .regularExpression) != nil {
            return "English"
        } else {
            return "Mixed or Other"
        }
    }

}
