//
//  Extensions.swift
//

import UIKit

extension UIColor {
    class public func getColorFromHex(_ hexString : String) -> UIColor {
        
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

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

public extension UIDevice {
    class var isIpad: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}
