//
//  UIDevice.swift
//

import UIKit

public extension UIDevice {
    class var isIpad: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}
