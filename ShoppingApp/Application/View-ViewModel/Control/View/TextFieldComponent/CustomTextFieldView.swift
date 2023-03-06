//
//  CustomTextFieldView.swift
//

import Foundation
import UIKit

class CustomTextFieldView: UIView {

    let label = UILabel()
    let textField = UITextField()
    
    let height: CGFloat = 60
    var tintColorActive: UIColor = App.Theme.current.package.accentColor
    var primaryBorderColour: UIColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)
    var title: String = "" {
        didSet{
            label.text = title
        }
    }
    var isSecureTextEntry: Bool = false {
        didSet{
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    var primaryBackgroundColor: UIColor = App.Theme.current.package.backgroundColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    func configureTextField(_ title: String, inputText: String = "", tintColorActive: UIColor = App.Theme.current.package.accentColor, primaryBorderColour: UIColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8), primaryBackgroundColor: UIColor = App.Theme.current.package.backgroundColor, isSecureTextEntry: Bool = false) {
        self.title = title
        self.accessibilityLabel = title
        self.label.accessibilityLabel = title
        self.textField.accessibilityLabel = title
        self.textField.text = inputText
        self.tintColorActive = tintColorActive
        self.primaryBorderColour = primaryBorderColour
        self.primaryBackgroundColor = primaryBackgroundColor
        self.isSecureTextEntry = isSecureTextEntry
        
        if inputText.count > 0 {
            addTextFieldAnimation(false)
        }
    }
}

extension CustomTextFieldView {
    
    private func setup() {
        textField.delegate = self
    }
    
    private func style() {
        backgroundColor = primaryBackgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = primaryBorderColour.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = height / 4
        
        // label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = primaryBorderColour
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        
        // textfield
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = tintColorActive
        textField.isHidden = true
        textField.textColor = primaryBorderColour
        textField.returnKeyType = .default
        textField.backgroundColor = .clear
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_: )))
        addGestureRecognizer(tap)
        
    }
    
    private func layout() {
        addSubview(label)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            // label
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            // textfield
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 2),
        ])
    }
    
    
    @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            addTextFieldAnimation(true)
        }
    }
}

// MARK: - Animations

extension CustomTextFieldView {
    
    private func addTextFieldAnimation(_ shouldBecomeFirstResponder: Bool) {

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) { [weak self] in
            guard let self = self else { return }
            // style
            self.backgroundColor = self.primaryBackgroundColor
            self.label.textColor = self.tintColorActive
            self.layer.borderWidth = 1
            self.layer.borderColor = self.label.textColor.cgColor
            self.textField.tintColor = self.tintColorActive
            
            // move
            let transpose = CGAffineTransform(translationX: -8, y: -24)
            let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.label.transform = transpose.concatenating(scale)
            
        } completion: { [weak self] position in
            self?.textField.isHidden = false
            if shouldBecomeFirstResponder {
                self?.textField.becomeFirstResponder()
            }
        }
    }
}

// MARK: - TextFieldDelegate

extension CustomTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            undo()
        }
        return true
    }
}

// MARK: - Actions

extension CustomTextFieldView {
    private func undo() {
        let size = UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in
            guard let self = self else { return }
            // style
            self.label.textColor = self.primaryBorderColour
            self.layer.borderColor = self.primaryBorderColour.cgColor
            self.layer.borderWidth = 1
            
            // visibility
            self.label.isHidden = false
            self.textField.isHidden = true
            self.textField.text = ""

            // move
            self.label.transform = .identity
        }
        size.startAnimation()
    }
}
