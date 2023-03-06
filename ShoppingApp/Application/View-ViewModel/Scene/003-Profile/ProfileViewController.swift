//
//  ProfileViewController.swift
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var logOutButton: AnimatedButton!
    @IBOutlet weak var tableView: UITableView!
    
    var cellData = [ProfileCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = App.StringConstants.profile
        view.backgroundColor = App.Theme.current.package.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: App.Theme.current.package.primaryTextColor]
        setupTableView()
        setupLogOutButton()
        setupCellData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.nib(), forCellReuseIdentifier: ProfileCell.identifier)
        tableView.register(ProfileHeaderView.nib(), forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
    }
    
    private func setupLogOutButton() {
        logOutButton.backgroundColor = App.Theme.current.package.accentColor
        logOutButton.setTitleColor(App.Theme.current.package.secondaryTextColor, for: .normal)
        logOutButton.setTitle(App.StringConstants.logOut, for: .normal)
        logOutButton.animationStyle = .springIn
    }
    
    @IBAction func logOutTapped(_ sender: AnimatedButton) {
        UserModel.clearData()
        AuthModel.username = nil
        let vc = AuthViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func setupCellData() {
        cellData.removeAll()
        cellData.append(ProfileCellViewModel(title: App.StringConstants.Username, body: UserModel.username))
        cellData.append(ProfileCellViewModel(title: App.StringConstants.d_o_b, body: UserModel.dob))
        cellData.append(ProfileCellViewModel(title: App.StringConstants.Firstname, body: UserModel.firstname))
        cellData.append(ProfileCellViewModel(title: App.StringConstants.Lastname, body: UserModel.lastName))
        cellData.append(ProfileCellViewModel(title: App.StringConstants.Address, body: UserModel.address))
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.identifier) as? ProfileHeaderView {
            header.configureHeader(ProfileHeaderViewModel(fullName: "\(UserModel.firstname ?? "") \(UserModel.lastName ?? "")", pointsEarned: UserModel.pointsEarned, walletBalance: UserModel.walletBalance))
            return header
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as? ProfileCell {
            cell.configure(with: cellData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
