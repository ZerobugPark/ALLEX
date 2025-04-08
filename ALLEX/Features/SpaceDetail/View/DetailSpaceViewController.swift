//
//  DetailSpaceViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources


final class DetailSpaceViewController: BaseViewController<DetailSpaceView, DetailSpaceViewModel> {
    
    
    typealias listDataSource = RxCollectionViewSectionedReloadDataSource<GymInfoSectionModel>
    typealias collectionViewDataSource = CollectionViewSectionedDataSource<GymInfoSectionModel>
    
    private lazy var dataSource: listDataSource = listDataSource (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            self?.configureCell(dataSource: dataSource, collectionView: collectionView, indexPath: indexPath, item: item) ?? UICollectionViewCell()
        },        configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            
            self?.configureSupplementary(dataSource: dataSource, collectionView: collectionView, kind: kind, indexPath: indexPath) ?? UICollectionReusableView()
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registerCollectionView()
        
        
        
    }
    
    override func bind() {
        
        let input = DetailSpaceViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.sections.drive(mainView.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

extension DetailSpaceViewController {
    
    private func registerCollectionView() {
        mainView.collectionView.register( GymHeaderCollectionViewCell.self,forCellWithReuseIdentifier: GymHeaderCollectionViewCell.id)
        
        mainView.collectionView.register(
            DifficultyLevelsCollectionViewCell.self,forCellWithReuseIdentifier: DifficultyLevelsCollectionViewCell.id)
        
        mainView.collectionView.register(
            FacilityInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: FacilityInfoCollectionViewCell.id
        )
        mainView.collectionView.register(
            FooterCellCollectionViewCell.self,
            forCellWithReuseIdentifier: FooterCellCollectionViewCell.id
        )
        mainView.collectionView.register(
            SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseId)
    }
    
    // MARK: - RxDataSource Function Definition
    private func configureCell(dataSource:  collectionViewDataSource, collectionView: UICollectionView, indexPath: IndexPath, item: GymInfoSectionItem) -> UICollectionViewCell {
        
        switch item {
        case let .headerItem(title, address, insta, imageURL):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GymHeaderCollectionViewCell.id,
                for: indexPath
            ) as! GymHeaderCollectionViewCell
            cell.configure(title: title, address: address, insta: insta,imageURL: imageURL)
            return cell
            
        case let .boulderingGradeItem(grade):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DifficultyLevelsCollectionViewCell.id,
                for: indexPath
            ) as! DifficultyLevelsCollectionViewCell
            cell.configure(with: grade)
            return cell
            
        case let .facilityItem(info):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FacilityInfoCollectionViewCell.id,
                for: indexPath
            ) as! FacilityInfoCollectionViewCell
            cell.configure(with: info)
            return cell
            
        case let .footerItem(message):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FooterCellCollectionViewCell.id,
                for: indexPath
            ) as! FooterCellCollectionViewCell
            cell.configure(message: message)
            return cell
        }
        
    }
    
    private func configureSupplementary(dataSource: collectionViewDataSource, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let sectionModel = dataSource.sectionModels[indexPath.section].section
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.reuseId, for: indexPath) as? SectionHeaderReusableView else {
            return UICollectionReusableView()
        }
    

        switch sectionModel {
        case .boulderingGrade(let title):
            headerView.configure(title: title)
        case .facilityInfo(let title):
            headerView.configure(title: title)
        default:
            headerView.configure(title: "")
        }
        return headerView
        
    }

}
