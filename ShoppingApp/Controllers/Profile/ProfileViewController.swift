//
//  ProfileViewController.swift
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var logOutButton: AnimatedButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringConstants.profile
        view.backgroundColor = Theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.primaryTextColor]
        setupTableView()
        setupLogOutButton()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.nib(), forCellReuseIdentifier: ProfileCell.identifier)
        tableView.register(ProfileHeaderView.nib(), forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
    }
    
    private func setupLogOutButton() {
        logOutButton.backgroundColor = Theme.accentColor
        logOutButton.setTitleColor(Theme.secondaryTextColor, for: .normal)
        logOutButton.setTitle("LOG OUT", for: .normal)
        logOutButton.animationStyle = .springIn
    }
    
    @IBAction func logOutTapped(_ sender: AnimatedButton) {
        let vc = AuthViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.identifier) as? ProfileHeaderView {
            header.configureHeader("\(CoreModel.shared.userModel?.firstname ?? "") \(CoreModel.shared.userModel?.lastName ?? "")", pointsEarned: CoreModel.shared.userModel?.pointsEarned ?? "", walletBalance: CoreModel.shared.userModel?.walletBalance ?? "")
            return header
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as? ProfileCell {
            switch indexPath.row {
            case 0:
                cell.configure(with: CoreModel.shared.userModel?.username ?? "", for: "User name")
            case 1:
                cell.configure(with: CoreModel.shared.userModel?.dob ?? "", for: "D.O.B")
            case 2:
                cell.configure(with: CoreModel.shared.userModel?.firstname ?? "", for: "First name")
            case 3:
                cell.configure(with: CoreModel.shared.userModel?.lastName ?? "", for: "Last name")
            case 4:
                cell.configure(with: CoreModel.shared.userModel?.address ?? "", for: "Address")
            default:
                cell.configure(with: "", for: "")
            }
            return cell
        }
        return UITableViewCell()
    }
}
