//
//  ProfileViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    enum Section: CaseIterable {
        case service
        case other
        
        var headerTitle: String? {
            switch self {
            case .service:
                return "서비스 이용 방침"
            case .other:
                return "기타"
            }
        }
        
        var items: [SettingsItem] {
            switch self {
            case .service:
                return [
                    SettingsItem(title: "개인정보 처리 방침", hasDisclosure: true),
                    SettingsItem(title: "서비스 이용약관", hasDisclosure: true),
                    SettingsItem(title: "버전정보", hasDisclosure: false, rightText: "v.1.0.2")
                ]
            case .other:
                return [
                    SettingsItem(title: "로그아웃", hasDisclosure: false),
                    SettingsItem(title: "탈퇴하기", hasDisclosure: false)
                ]
            }
        }
    }
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Set title
        title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Back button
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // Dark mode appearance
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }
        
        // Add tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        // Set table view header and footer view backgrounds
        let headerFooterView = UIView()
        headerFooterView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        tableView.tableHeaderView?.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .clear
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let sectionType = Section.allCases[safe: indexPath.section],
              let item = sectionType.items[safe: indexPath.row] else {
            return cell
        }
        
        // Configure cell for dark mode
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.title
        configuration.textProperties.color = .white
        cell.contentConfiguration = configuration
        
        // Set right text if available (이 부분을 수정했습니다)
        if let rightText = item.rightText {
            let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            detailLabel.text = rightText
            detailLabel.textColor = UIColor.lightGray
            detailLabel.font = UIFont.systemFont(ofSize: 15)
            detailLabel.textAlignment = .right
            cell.accessoryView = detailLabel
        } else if item.hasDisclosure {
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
        } else {
            cell.accessoryType = .none
            cell.accessoryView = nil
        }
        
        // Set cell's background color
        cell.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0)
        
        // Configure selected background color
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Section.allCases[safe: section] else { return nil }
        return sectionType.headerTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.gray
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sectionType = Section.allCases[safe: indexPath.section],
              let item = sectionType.items[safe: indexPath.row] else {
            return
        }
        
        // Handle cell selection
        switch (sectionType, indexPath.row) {
        case (.service, 0):
            print("개인정보 처리 방침")
            // 개인정보 처리 방침 화면으로 이동
        case (.service, 1):
            print("서비스 이용약관")
            // 서비스 이용약관 화면으로 이동
        case (.other, 0):
            print("로그아웃")
            // 로그아웃 처리
        case (.other, 1):
            print("탈퇴하기")
            // 탈퇴 처리
        default:
            break
        }
    }
}

// MARK: - Safe subscript extension
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


//class ProfileViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .setAllexColor(.backGround)
//    }
//    
//
// 
//
//}
