//
//  AlertView.swift
//

import UIKit

public class AlertViewItem: NSObject {
    public var headerText: String?
    public var image: UIImage?
    public var headerColor: UIColor = .darkGray
    public var messageText: String?
    public var acceptText: String?
    public var cancelText: String?
    
    public init(image: UIImage?, headerText: String, headerColor: UIColor = .darkGray, messageText: String? = nil, acceptButtonText: String, cancelButtonText: String) {
        super.init()
        self.headerText = headerText
        self.image = image
        self.headerColor = headerColor
        self.messageText = messageText
        self.acceptText = acceptButtonText
        self.cancelText = cancelButtonText
    }
}

open class AlertView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: AnimatedButton!
    @IBOutlet weak var acceptButton: AnimatedButton!
    
    var acceptHandler: (() -> ())?
    
    public class func show(alertItem: AlertViewItem, acceptHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first {
                let nibViews = UINib(nibName: "AlertView", bundle: Bundle.main).instantiate(withOwner: nil)
                if nibViews.count > 0, let nibView = nibViews[0] as? AlertView {
                    nibView.frame = keyWindow.bounds
                    nibView.configureAlert(item: alertItem, acceptHandler: acceptHandler)
                    keyWindow.addSubview(nibView)
                    Animations.popIn(nibView.baseView)
                }
            } else {
                fatalError("Alert View: Nib not instantiated")
            }
        }
    }
    
    public class func hide() {
        if let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first {
            keyWindow.subviews.forEach({ (view) in
                if view.isKind(of: self), let alertView = view as? AlertView {
                    alertView.removePopupAnimation {
                        alertView.removeFromSuperview()
                    }
                }
            })
        }
    }
    
    public func configureAlert<viewItem>(item: viewItem, acceptHandler: (() -> ())? = nil) {
        baseView.layer.cornerRadius = 8
        baseView.backgroundColor = App.Theme.current.package.backgroundColor
        baseView.configureShadowWithCorner(shadowColor: App.Theme.current.package.accentColor, shadowOpacity: 0.2)
        acceptButton.backgroundColor = App.Theme.current.package.accentColor
        acceptButton.setTitleColor(App.Theme.current.package.secondaryTextColor, for: .normal)
        acceptButton.animationStyle = .springIn
        acceptButton.cornerRadius = 4
        
        cancelButton.borderColor = App.Theme.current.package.accentColor
        cancelButton.setTitleColor(App.Theme.current.package.accentColor, for: .normal)
        cancelButton.animationStyle = .springIn
        cancelButton.borderColor = App.Theme.current.package.accentColor
        cancelButton.layer.borderWidth = 1
        cancelButton.cornerRadius = 4
        
        self.acceptHandler = acceptHandler
        
        if let data = item as? AlertViewItem {
            
            if let image = data.image {
                imageView.image = image
            }
            
            if let headerText = data.headerText {
                headerLabel.text = headerText
                headerLabel.textColor = data.headerColor
            }
                        
            if let messageText = data.messageText {
                messageLabel.textColor = App.Theme.current.package.accentColor.withAlphaComponent(0.8)
                messageLabel.text = messageText
            }
            
            if let acceptText = data.acceptText {
                acceptButton.setTitle(acceptText, for: .normal)
            }
            
            if let cancelText = data.cancelText {
                cancelButton.setTitle(cancelText, for: .normal)
            }
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        removePopupAnimation { [weak self] in
            if let action = self?.acceptHandler {
                action()
            }
            self?.removeFromSuperview()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        removePopupAnimation { [weak self] in
            self?.removeFromSuperview()
        }
    }
    
    func removePopupAnimation(completion:@escaping (() -> ())) {
        Animations.popOut(baseView) {
            completion()
        }
    }
    
    func createText(firstTextTitle: String, firstTextFont: UIFont = .systemFont(ofSize: 14), firstTextColor: UIColor = .lightGray, secondTextTitle: String, secondTextFont: UIFont = .boldSystemFont(ofSize: 16), secondTextColor: UIColor = .darkGray) -> NSMutableAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: firstTextTitle,attributes: [NSAttributedString.Key.font : firstTextFont, NSAttributedString.Key.foregroundColor : firstTextColor])
        attrString.append(NSMutableAttributedString(string: secondTextTitle, attributes: [NSAttributedString.Key.font : secondTextFont, NSAttributedString.Key.foregroundColor : secondTextColor]))
        return attrString
    }
    
}
