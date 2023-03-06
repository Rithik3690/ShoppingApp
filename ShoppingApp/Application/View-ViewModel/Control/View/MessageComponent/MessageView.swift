//
//  MessageView.swift
//  

import UIKit

open class MessageView: UIView {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var messageText: String = "" {
        didSet {
            messageLabel.text = messageText
        }
    }
    
    public class func show(_ message: String) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first {
                let nibViews = UINib(nibName: "MessageView", bundle: Bundle.main).instantiate(withOwner: nil)
                if nibViews.count > 0, let nibView = nibViews[0] as? MessageView {
                    nibView.frame = keyWindow.bounds
                    keyWindow.addSubview(nibView)
                    nibView.messageText = message
                    nibView.messageLabel.accessibilityLabel = message
                    nibView.baseView.layer.cornerRadius = 4
                    Animations.slideFromTop(nibView.baseView)
                    nibView.configureTapGestureRecognizer()
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                        timer.invalidate()
                        nibView.hide()
                    }
                }
            } else {
                fatalError("Message View: Nib not instantiated")
            }
        }
    }

    @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            hide()
        }
    }
    
    private func hide() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first {
                keyWindow.subviews.forEach({ (view) in
                    if view.isKind(of: MessageView.self), let messageView = view as? MessageView {
                        Animations.slideUp(messageView, duration: 1) {
                            messageView.removeFromSuperview()
                        }
                    }
                })
            }
        }
    }
    
    private func configureTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_: )))
        addGestureRecognizer(tap)
    }
    
}
