//
//  AuthViewController.swift
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var signInButton: LoadingButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    
    let usernameTextfield = CustomTextFieldView()
    let passwordTextfield = CustomTextFieldView()
    
    private let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = App.Theme.current.package.backgroundColor
        signInButton.animationStyle = .springIn
        signInButton.setTitleColor(App.Theme.current.package.secondaryTextColor, for: .normal)
        signInButton.backgroundColor = App.Theme.current.package.accentColor
        containerView.configureShadowWithCorner(shadowColor: App.Theme.current.package.accentColor, shadowOpacity: 0.8)
        containerView.backgroundColor = App.Theme.current.package.backgroundColor
        layoutTextField(usernameTextFieldView, textFieldView: usernameTextfield, title: App.StringConstants.Username, tintColorActive: App.Theme.current.package.accentColor)
        layoutTextField(passwordTextFieldView, textFieldView: passwordTextfield, title: App.StringConstants.Password, tintColorActive: App.Theme.current.package.accentColor, isSecureTextEntry: true)
    }
    
    private func layoutTextField(_ baseView: UIView, textFieldView: CustomTextFieldView, title: String, inputText: String = "", tintColorActive: UIColor = App.Theme.current.package.accentColor, primaryBorderColour: UIColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8), primaryBackgroundColor: UIColor = App.Theme.current.package.backgroundColor, isSecureTextEntry: Bool = false) {
        baseView.addSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: baseView.leadingAnchor, multiplier: 2),
            baseView.trailingAnchor.constraint(equalToSystemSpacingAfter: textFieldView.trailingAnchor, multiplier: 2),
        ])
        textFieldView.configureTextField(title, inputText: inputText, tintColorActive: tintColorActive, primaryBorderColour: primaryBorderColour, primaryBackgroundColor: primaryBackgroundColor, isSecureTextEntry: isSecureTextEntry)
    }
    
    @IBAction func signInPressed(_ sender: LoadingButton) {
        if let username = usernameTextfield.textField.text, let password = passwordTextfield.textField.text, username.count > 0, password.count > 0 {
            authenticateUser(sender, with: username, for: password)
        } else {
            MessageView.show(App.StringConstants.fieldsEmptyError)
        }
    }
    
    private func authenticateUser(_ sender: LoadingButton, with username: String, for password: String) {
        sender.startLoadingAnimation()
        dispatchGroup.enter()
        Router.getHttpServiceForAPI(App.StringConstants.userDetailsURL) { [weak self] json in
            if let data = json as? [String: Any] {
                UserModel.setValues(data)
                AuthModel.username = data[App.StringConstants.username] as? String
            }
            self?.dispatchGroup.leave()
        } onFailure: { [weak self] error in
            MessageView.show(error?.localizedDescription ?? App.StringConstants.invalidURLError)
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            sender.stopLoadingAnimation()
            if AuthModel.username?.equalsIgnoreCase(username) == true && password == "1234" {
                self?.navigateToHomeVC()
            } else {
                MessageView.show(App.StringConstants.incorrectAuthDetailsError)
                UserModel.clearData()
                AuthModel.username = nil
            }
        }

    }
    
    private func navigateToHomeVC() {
        let vc = UINavigationController(rootViewController: HomePageViewController())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
    }
}

