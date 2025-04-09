//
//  SearchListViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import Foundation

import RxCocoa
import RxSwift


final class SearchListViewModel: BaseViewModel {
    
    struct Input {
        let viewdidLoad: Observable<Void>
        let searchText: Observable<ControlProperty<String>.Element>
        let cancelButttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchResult: Driver<[Gym]>
        let infoLabel: Driver<Bool>
        let hideKeyboard: Driver<Void>
    }
    
    
    private var resultData: [Gym] = []
    
    var disposeBag = DisposeBag()
    
    private var sharedData: SharedDataModel
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let searchResult = BehaviorRelay(value: resultData)
        let infoLabel = BehaviorRelay(value: true)
        let hideKeyboard = PublishRelay<Void>()
        
        input.viewdidLoad.bind(with: self) { owner, _ in
           
            owner.resultData =  owner.getData()
            searchResult.accept(owner.resultData)
            infoLabel.accept(true)
            
        }.disposed(by: disposeBag)
        
        
        input.searchText.bind(with: self) { owner, str in
            
            owner.resultData = owner.filterArray(str: str)
            if !owner.resultData.isEmpty {
                infoLabel.accept(true)
            } else {
                infoLabel.accept(false)
            }
            
            hideKeyboard.accept(())
            searchResult.accept(owner.resultData)
            
        }.disposed(by: disposeBag)
        
        input.cancelButttonTap.bind(with: self) { owner, _ in
            
            owner.resultData =  owner.getData()
            searchResult.accept(owner.resultData)
            
            infoLabel.accept(true)
            hideKeyboard.accept(())
            
        }.disposed(by: disposeBag)
        
        return Output(searchResult: searchResult.asDriver(onErrorJustReturn: []), infoLabel: infoLabel.asDriver(onErrorJustReturn: true), hideKeyboard: hideKeyboard.asDriver(onErrorJustReturn: ()))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}

extension SearchListViewModel {
    
    private func getData() -> [Gym] {
        return sharedData.getData(for: Gym.self)!
    }
    
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
