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
 
    func configureHeader(_ fullName: String, pointsEarned: String, walletBalance: String) {
        containerView.backgroundColor = Theme.accentColor.withAlphaComponent(0.1)
        userDetailsHeaderLabel.textColor = Theme.primaryTextColor
        walletBalanceHeaderLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.8)
        pointsEarnerHeaderLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.8)
        walletBalanceLabel.textColor = Theme.primaryTextColor
        pointsEarnedLabel.textColor = Theme.primaryTextColor
        memberSinceLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.8)
        fullNameLabel.textColor = Theme.primaryTextColor
        profileImageView.layer.cornerRadius = 35
        fullNameLabel.text = fullName
        walletBalanceLabel.text = walletBalance
        pointsEarnedLabel.text = pointsEarned
    }
}
