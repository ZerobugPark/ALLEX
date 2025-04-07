//
//  ProfileViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


final class ProfileViewController: BaseViewController<ProfileView, ProfileViewModel> {
    
    var coordinator: ProfileCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    

    private func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }

    override func bind() {
        
            
        
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.isChangedName.drive(mainView.profileButton.title.rx.text).disposed(by: disposeBag)
        
        mainView.profileButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.showProfileSetting()
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
          return Section.allCases.count
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          guard let sectionType = Section.allCases[safe: section] else { return 0 }
          return sectionType.items.count
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        guard let sectionType = Section.allCases[safe: indexPath.section],
              let item = sectionType.items[safe: indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .setAllexColor(.textSecondary)

        if let rightText = item.rightText {
            cell.detailTextLabel?.text = rightText
            cell.detailTextLabel?.textColor = .setAllexColor(.textSecondary)
        } else {
            cell.detailTextLabel?.text = nil
        }
        
        if item.hasDisclosure {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        cell.backgroundColor = .setAllexColor(.backGroundSecondary)
        cell.selectionStyle = .none  // 선택 효과 제거
        
        return cell
    }


      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          guard let sectionType = Section.allCases[safe: section] else { return nil }
          

          return sectionType.headerTitle
      }
      
      func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
          if let headerView = view as? UITableViewHeaderFooterView {
              headerView.textLabel?.textColor = .setAllexColor(.textPirmary)
              headerView.textLabel?.font = .setAllexFont(.bold_14)
          }
      }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sectionType = Section.allCases[safe: indexPath.section],
              let _ = sectionType.items[safe: indexPath.row] else {
            return
        }
        
        // Handle cell selection
        switch (sectionType, indexPath.row) {
        case (.service, 0):
            coordinator?.showPrivacyPolicy()
        case (.service, 1):
            coordinator?.showOfficialAccount()
        case (.other, 0):
            let msg = "탈퇴하시면 모든 데이터가 삭제됩니다. 그래도 탈퇴하시겠습니까?"
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                self.coordinator?.logout()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert,animated: true)
        
        default:
            break
        }
    }
    

}

extension ProfileViewController {
    
    struct SettingsItem {
        let title: String
        let hasDisclosure: Bool
        var rightText: String?
        
        init(title: String, hasDisclosure: Bool, rightText: String? = nil) {
            self.title = title
            self.hasDisclosure = hasDisclosure
            self.rightText = rightText
        }
    }

    enum Section: CaseIterable {
        case service
        case other
        
        var items: [SettingsItem] {
            switch self {
            case .service:
                return [
                    SettingsItem(title: "개인정보 처리 방침", hasDisclosure: true),
                    SettingsItem(title: "문의하기", hasDisclosure: true),
                    SettingsItem(title: "버전정보", hasDisclosure: false, rightText: Version.current)
                ]
            case .other:
                return [
                    SettingsItem(title: "탈퇴하기", hasDisclosure: false)
                ]
            }
        }
        
        var headerHeight: CGFloat {
            switch self {
            case .service, .other:
                return 40
            }
        }
        
        var headerTitle: String? {
            switch self {
            case .service:
                return "서비스"
            case .other:
                return "기타"
            }
        }
    }

}
