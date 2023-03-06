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
    
    var detailModel: DetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = App.StringConstants.detail
        view.backgroundColor = App.Theme.current.package.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: App.Theme.current.package.primaryTextColor]
        layoutViews()
        styleViews()
        if let model = detailModel {
            configure(model)
        }
    }
    
    private func layoutViews() {
        itemImageViewWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 : App.ScreenSize.width
        brandLabelWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 * 0.95 : App.ScreenSize.width * 0.9
        itemLabelwWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 * 0.95 : App.ScreenSize.width * 0.9
        priceViewWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 * 0.95 : App.ScreenSize.width * 0.9
        seperatorWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 * 0.95 : App.ScreenSize.width * 0.9
        descriptionLabelWidthConstraint.constant = UIDevice.isIpad ? App.ScreenSize.width/2 * 0.95 : App.ScreenSize.width * 0.9
    }
    
    private func styleViews() {
        brandLabel.textColor = App.Theme.current.package.accentColor.withAlphaComponent(0.7)
        itemLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.6)
        offerPriceLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
        originalPriceLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.6)
        discountLabel.textColor = App.Theme.current.package.accentColor
        seperatorView.backgroundColor = App.Theme.current.package.accentColor.withAlphaComponent(0.1)
        descriptionLabel.textColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.6)
        addToCartButton.setTitle(App.StringConstants.addToCart, for: .normal)
        addToCartButton.backgroundColor = App.Theme.current.package.accentColor
        addToCartButton.setTitleColor(App.Theme.current.package.secondaryTextColor, for: .normal)
        addToCartButton.animationStyle = .springIn
    }
    
    private func configure(_ model: DetailModel) {
        itemImageView.loadImageFromAPI(with: model.productUrl)
        brandLabel.text = model.brand
        itemLabel.text = model.name
        offerPriceLabel.text = "₹\(model.offerPrice ?? "")"
        originalPriceLabel.attributedText = getStrikeThroughText("₹\(model.price ?? "")")
        discountLabel.text = "Hurray!! You get \(getOfferPercentage(model.price, offerPrice: model.offerPrice))% off on this product"
        descriptionLabel.text = model.productDesc
    }
    
    @IBAction func addToCartTapped(_ sender: LoadingButton) {
        AlertView.show(alertItem: AlertViewItem(image: App.Images.cart_success,headerText: App.StringConstants.CONGRATULATIONS, headerColor: App.Theme.current.package.accentColor, messageText: App.StringConstants.itemAddedToCart, acceptButtonText: App.StringConstants.addMore, cancelButtonText: App.StringConstants.dismiss)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
