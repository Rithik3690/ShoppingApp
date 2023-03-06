//
//  HomeRewardsProgramCell.swift
//  

import UIKit

class HomeRewardsProgramCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    static let identifier = "HomeRewardsProgramCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HomeRewardsProgramCell.identifier, bundle: nil)
    }

    func configure(_ model: RewardModel) {
        containerView.backgroundColor = App.Theme.current.package.accentColor.withAlphaComponent(0.1)
        imageView.image = model.image
        textLabel.text = model.text
        textLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
    }
}
