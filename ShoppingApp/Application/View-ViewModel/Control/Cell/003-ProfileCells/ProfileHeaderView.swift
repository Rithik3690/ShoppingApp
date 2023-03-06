//
//  ProfileHeaderView.swift
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var userDetailsHeaderLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var walletBalanceHeaderLabel: UILabel!
    @IBOutlet weak var pointsEarnerHeaderLabel: UILabel!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier = "ProfileHeaderView"
        
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ProfileHeaderView.identifier, bundle: nil)
    }
 
    func configureHeader(_ viewModel: ProfileHeaderViewModel) {
        containerView.backgroundColor = App.Theme.current.package.backgroundColor
        containerView.backgroundColor = App.Theme.current.package.accentColor.withAlphaComponent(0.1)
        userDetailsHeaderLabel.textColor = App.Theme.current.package.primaryTextColor
        walletBalanceHeaderLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
        pointsEarnerHeaderLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
        walletBalanceLabel.textColor = App.Theme.current.package.primaryTextColor
        pointsEarnedLabel.textColor = App.Theme.current.package.primaryTextColor
        memberSinceLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
        fullNameLabel.textColor = App.Theme.current.package.primaryTextColor
        profileImageView.layer.cornerRadius = 35
        fullNameLabel.text = viewModel.fullName
        walletBalanceLabel.text = viewModel.walletBalance
        pointsEarnedLabel.text = viewModel.pointsEarned
    }
}
