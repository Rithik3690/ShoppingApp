//
//  ReusableFunctions.swift
//

import Foundation

public func getOfferPercentage(_ price: String?, offerPrice: String?) -> String {
    guard let price = price, let priceValue = Double(price), let offerPrice = offerPrice, let offerPriceValue = Double(offerPrice) else { return "" }
    return "\(100 - (Int(offerPriceValue/priceValue * 100)))% off"
}

public func getStrikeThroughText(_ text: String) -> NSMutableAttributedString {
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
    return attributeString
}
