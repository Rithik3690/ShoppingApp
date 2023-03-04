//
//  CustomButton.swift
//  

import UIKit

@IBDesignable
open class CustomButton: UIButton {

    var insetTop: CGFloat? = 0
    var insetLeft: CGFloat? = 0
    var insetBottom: CGFloat? = 0
    var insetRight: CGFloat? = 0
    @IBInspectable var borderColor: UIColor = UIColor(red: (37.0/255.0), green: (252.0/255), blue: (244.0/255.0), alpha: 1.0)
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    public var alphaFadeValue: CGFloat = 0.74
    
    
    open override func draw(_ rect: CGRect) {
        setRoundCorners(cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
        super.draw(rect.inset(by: UIEdgeInsets(top: insetTop!, left: insetLeft!, bottom: insetBottom!, right: insetRight!)))
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = backgroundColor?.withAlphaComponent(alphaFadeValue)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = backgroundColor?.withAlphaComponent(1)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    public func setRoundCorners(_ radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
