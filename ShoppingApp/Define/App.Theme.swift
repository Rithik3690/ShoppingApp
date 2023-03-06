//
//  App.Theme.swift
//

import UIKit

protocol ColorPackage {
    var accentColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
}


extension App {
    enum Theme {
        case dark
        case light
        
        public static var current: Theme = .light
        var package: ColorPackage {
            switch self {
            case .dark:
                return ThemePackage()
            case .light:
                return ThemePackage()
            }
        }
    }
    
    struct ThemePackage: ColorPackage {
        var accentColor: UIColor = UIColor(named: "accentColor")!
        var backgroundColor: UIColor = UIColor(named: "backgroundColor")!
        var primaryTextColor: UIColor = UIColor(named: "primaryTextColor")!
        var secondaryTextColor: UIColor = UIColor(named: "secondaryTextColor")!
    }
}


