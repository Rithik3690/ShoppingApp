//
//  HomeStyleTwoCell.swift
//  

import UIKit

class HomeStyleTwoCell: UICollectionViewCell {
    
    static let identifier = "HomeStyleTwoCell"
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HomeStyleTwoCell.identifier, bundle: nil)
    }

    func configure(_ model: HomePageModel) {
        containerView.configureShadowWithCorner(shadowColor: Theme.accentColor, shadowOpacity: 0.8)
        containerView.backgroundColor = Theme.backgroundColor
        itemImageView.loadImageFromAPI(with: model.productUrl)
        brandLabel.text = model.brand
        brandLabel.textColor = Theme.accentColor.withAlphaComponent(0.7)
        itemLabel.text = model.name
        itemLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.6)
        offerPriceLabel.text = "₹\(model.offerPrice ?? "")"
        offerPriceLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.8)
        originalPriceLabel.attributedText = getStrikeThroughText("₹\(model.price ?? "")")
        originalPriceLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.6)
        discountLabel.text = getOfferPercentage(model.price, offerPrice: model.offerPrice)
        discountLabel.textColor = Theme.accentColor
    }
    
    private func getOfferPercentage(_ price: String?, offerPrice: String?) -> String {
        guard let price = price, let priceValue = Double(price), let offerPrice = offerPrice, let offerPriceValue = Double(offerPrice) else { return "" }
        return "\(100 - (Int(offerPriceValue/priceValue * 100)))% off"
    }
    
    private func getStrikeThroughText(_ text: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
