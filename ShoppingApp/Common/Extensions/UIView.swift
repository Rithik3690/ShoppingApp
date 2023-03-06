//
//  UIView.swift
//

import UIKit

extension UIView {
    func configureShadowWithBorderAndCorner(withBorder borderWidth: CGFloat = 0.5, borderColor: UIColor = .systemGray, cornerRadius: CGFloat = 6.0, shadowColor: UIColor = .systemGray, shadowOpacity: Float = 0.54, shadowRadius: CGFloat = 3.0, shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5)) {
        layer.masksToBounds = false
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    func configureShadowWithCorner(withCorner cornerRadius: CGFloat = 6.0, shadowColor: UIColor = .systemGray, shadowOpacity: Float = 0.54, shadowRadius: CGFloat = 3.0, shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5)) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
}
