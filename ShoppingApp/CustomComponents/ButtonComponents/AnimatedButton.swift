//
//  AnimatedButton.swift
//

import UIKit

enum AnimationStyle {
    case translationX
    case translationY
    case translationXAndY
    case springOut
    case springIn
}

class AnimatedButton: CustomButton {
    
    var animationStyle: AnimationStyle? = nil
    var translationX: CGFloat = -2
    var translationY: CGFloat = 2
    var springInScaleXAndY: CGFloat = 0.9
    var springOutScaleXAndY: CGFloat = 1.2
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switch animationStyle {
        case .translationX:
            transform = CGAffineTransform(translationX: translationX, y: 0)
        case .translationY:
            transform = CGAffineTransform(translationX: 0, y: translationY)
        case .translationXAndY:
            transform = CGAffineTransform(translationX: translationX, y: translationY)
        case .springIn:
            transform = CGAffineTransform(scaleX: springInScaleXAndY, y: springInScaleXAndY)
        case .springOut:
            transform = CGAffineTransform(scaleX: springOutScaleXAndY, y: springOutScaleXAndY)
        case .none:
            transform = CGAffineTransform.identity
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = CGAffineTransform.identity
    }
}
