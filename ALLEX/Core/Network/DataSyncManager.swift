//
//  DataSyncManager.swift
//  ALLEX
//
//  Created by youngkyun park on 8/27/25.
//

import Foundation
import RxSwift

final class DataSyncManager {
    static let shared = DataSyncManager()
    private var disposeBag = DisposeBag()
    private let spaceRepo: ClimbingSpaceRepository

    private init(spaceRepo: ClimbingSpaceRepository = RealmClimbingSpaceRepository()) {
        self.spaceRepo = spaceRepo
    }

    func syncIfNeeded() async {
        
        ///   콜백 기반 비동기 코드를 async awiat로 변경 await withCheckedContinuation { continuation i
        await withCheckedContinuation { continuation in
            NetworkManger.shared.fetchRemoteDBVersion()
                .subscribe(onSuccess: { [weak self] response in
                    guard let self else { return }
                    switch response {
                    case .success(let value):
                        let versions: [DatabaseVersion] = self.convertToGyms(from: value, type: DatabaseVersion.self)
                        let remoteVersion = versions.first?.version ?? ""
                        let localVersion = UserDefaultManager.databaseVersion

                        Task {
                            if remoteVersion != localVersion {
                                await self.refreshAllDataFromGoogleDB(remoteVersion)
                            }
                            continuation.resume() // async 함수 종료
                        }
                    case .failure(let error):
                        print("동기화 실패:", error)
                        continuation.resume()
                    }
                }, onFailure: { error in
                    print("네트워크 자체 에러:", error)
                    continuation.resume()
                })
                .disposed(by: disposeBag)
        }
        
     
    }

    private func refreshAllDataFromGoogleDB(_ version: String) async {
        let result = await NetworkManger.shared.callRequest()
        
        switch result {
        case .success(let value):
            let brands = convertToGyms(from: value[0], type: Brand.self)
            let gyms = convertToGyms(from: value[1], type: Gym.self)
            let gymGrades = convertToGyms(from: value[2], type: GymGrades.self)
            let bouldering = convertToGyms(from: value[3], type: Bouldering.self)
            
            await saveToRealm(brands: brands, gyms: gyms, gymGrades: gymGrades, bouldering: bouldering)
            
            syncBoulderingData(brands: brands, gyms: gyms, gymGrades: gymGrades, bouldering: bouldering)
            
            UserDefaultManager.databaseVersion = version

        case .failure(let failure):
            print("error", failure)
            
        }
        
        
    }
    
    @MainActor
    private func saveToRealm(brands: [Brand], gyms: [Gym], gymGrades: [GymGrades], bouldering: [Bouldering]) {
        do {
            try spaceRepo.upsertAll(brands: brands, gyms: gyms, grades: gymGrades, boulders: bouldering)
        } catch {
            print("렘 저장 오류", error)
        }
    }

}
extension DataSyncManager {
    
    private func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
    
    
    func loadRealmRepository() {
        
        do {
            let brands = try spaceRepo.fetchBrands()
            let gyms = try spaceRepo.fetchAllGyms()
            let gymGrades = try spaceRepo.fetchGymGrades()
            let bouldering = try spaceRepo.fetchBouldering()
            
            syncBoulderingData(brands: brands, gyms: gyms, gymGrades: gymGrades, bouldering: bouldering)
            
        } catch {
            print("Realm fetch 실패:", error)
        }

    }
    
    func syncBoulderingData(brands: [Brand], gyms: [Gym], gymGrades: [GymGrades], bouldering: [Bouldering]) {
        
        //sharedData.updateData(data: brands, for: Brand.self)
        //sharedData.updateData(data: gyms, for: Gym.self)
        //sharedData.updateData(data: gymGrades, for: GymGrades.self)
        //sharedData.updateData(data: bouldering, for: Bouldering.self)
    }
    
}

