//
//  Animations.swift
//

import UIKit

public class Animations {
    public static func popIn(_ view: UIView, delay: CGFloat = 0, duration: CGFloat = 0.5, completion: (() -> ())? = nil) {
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: 0.75, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        }) { _ in
            completion?()
        }
    }
    
    public static func popOut(_ view: UIView, delay: CGFloat = 0, duration: CGFloat = 0.5, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: 0.75, initialSpringVelocity: 1.5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            view.alpha = 0
        }) { _ in
            completion?()
        }
    }
    
    public static func slideFromTop(_ view: UIView, fromY: CGFloat = App.ScreenSize.height, delay: CGFloat = 0, duration: CGFloat = 0.5, yPosition: CGFloat = 0, usingSpringWithDamping: CGFloat = 1, initialSpringVelocity: CGFloat = 1, completion: (() -> ())? = nil) {
        view.frame.origin.y = -fromY
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: {
            view.alpha = 1
            view.frame.origin.y = yPosition
        }, completion:  { _ in
            completion?()
        })
    }
    
    public static func slideUp(_ view: UIView, toY: CGFloat = App.ScreenSize.height, delay: CGFloat = 0, duration: CGFloat = 0.5, usingSpringWithDamping: CGFloat = 1, initialSpringVelocity: CGFloat = 1, completion: (() -> ())?) {
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: {
            view.alpha = 0
            view.frame.origin.y = -toY
        }, completion: { _ in
            completion?()
        })
    }
}
