//
//  HomeStyleOneCell.swift
//  

import UIKit

class HomeStyleOneCell: UICollectionViewCell {
    
    static let identifier = "HomeStyleOneCell"

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HomeStyleOneCell.identifier, bundle: nil)
    }
    
    func configure(_ model: ItemModel) {
        containerView.configureShadowWithCorner(shadowColor: App.Theme.current.package.accentColor, shadowOpacity: 0.8)
        containerView.backgroundColor = App.Theme.current.package.backgroundColor
        itemImageView.loadImageFromAPI(with: model.productUrl)
        brandLabel.text = model.brand
        brandLabel.textColor = App.Theme.current.package.accentColor.withAlphaComponent(0.7)
        itemLabel.text = model.name
        itemLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.6)
        offerPriceLabel.text = "₹\(model.offerPrice ?? "")"
        offerPriceLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
        originalPriceLabel.attributedText = getStrikeThroughText("₹\(model.price ?? "")")
        originalPriceLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.6)
        discountLabel.text = getOfferPercentage(model.price, offerPrice: model.offerPrice)
        discountLabel.textColor = App.Theme.current.package.accentColor
    }

}
