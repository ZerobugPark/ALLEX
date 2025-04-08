//
//  DetailSpaceView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

import SnapKit


final class DetailSpaceView: BaseView {
    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: creatCompositionalLayout())
    
    override func configureHierarchy() {
       
        self.addSubview(collectionView)
    
    }
    
    override func configureLayout() {
   
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        

    }
    
    override func configureView() {
        
        
        collectionView.backgroundColor = .setAllexColor(.backGround)
        collectionView.showsVerticalScrollIndicator = false
    
    }
    
    private func creatCompositionalLayout() -> UICollectionViewLayout {
        
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            if sectionIndex == 0 {
                // MARK: - createHeaderSection
                // Create item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Create group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(210)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Create section
                let section = NSCollectionLayoutSection(group: group)
                
                // Add header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                
                return section
                
            } else if sectionIndex == 1 {
                // MARK: - createDifficultyLevelsSection

                // Create item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1 / 4),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                // Create group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Create section
                let section = NSCollectionLayoutSection(group: group)
           //     section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                
                // Add header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
                
            } else if sectionIndex == 2 { 
                // MARK: - createFacilityInfoSection
                // Create item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                // Create group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Create section
                let section = NSCollectionLayoutSection(group: group)
                
                // Add header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
                
            } else {
                // MARK: - createFooterSection
                // Create item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(60)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Create group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(60)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                // Create section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

                return section
            }
            
        }
        return layout
    
    }
    

}


