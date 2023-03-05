//
//  DetailViewController.swift
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var addToCartButton: LoadingButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemLabelwWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelWidthConstraint: NSLayoutConstraint!
    
    var homePageModel: HomePageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringConstants.detail
        view.backgroundColor = Theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.primaryTextColor]
        layoutViews()
        styleViews()
        if let model = homePageModel {
            configure(model)
        }
    }
    
    private func layoutViews() {
        itemImageViewWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 : App.mainWidth
        brandLabelWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 * 0.95 : App.mainWidth * 0.9
        itemLabelwWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 * 0.95 : App.mainWidth * 0.9
        priceViewWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 * 0.95 : App.mainWidth * 0.9
        seperatorWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 * 0.95 : App.mainWidth * 0.9
        descriptionLabelWidthConstraint.constant = UIDevice.isIpad ? App.mainWidth/2 * 0.95 : App.mainWidth * 0.9
    }
    
    private func styleViews() {
        brandLabel.textColor = Theme.accentColor.withAlphaComponent(0.7)
        itemLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.6)
        offerPriceLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.8)
        originalPriceLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.6)
        discountLabel.textColor = Theme.accentColor
        seperatorView.backgroundColor = Theme.accentColor.withAlphaComponent(0.1)
        descriptionLabel.textColor = Theme.primaryTextColor.withAlphaComponent(0.6)
        addToCartButton.setTitle("ADD TO CART", for: .normal)
        addToCartButton.backgroundColor = Theme.accentColor
        addToCartButton.setTitleColor(Theme.secondaryTextColor, for: .normal)
        addToCartButton.animationStyle = .springIn
    }
    
    private func configure(_ model: HomePageModel) {
        itemImageView.loadImageFromAPI(with: model.productUrl)
        brandLabel.text = model.brand
        itemLabel.text = model.name
        offerPriceLabel.text = "₹\(model.offerPrice ?? "")"
        originalPriceLabel.attributedText = getStrikeThroughText("₹\(model.price ?? "")")
        discountLabel.text = "Hurray!! You get \(getOfferPercentage(model.price, offerPrice: model.offerPrice))% off on this product"
        descriptionLabel.text = model.productDesc
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
    
    @IBAction func addToCartTapped(_ sender: LoadingButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
