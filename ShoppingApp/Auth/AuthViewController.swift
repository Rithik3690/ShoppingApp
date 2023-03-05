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
        view.backgroundColor = Theme.backgroundColor
        signInButton.animationStyle = .springIn
        signInButton.setTitleColor(Theme.secondaryTextColor, for: .normal)
        signInButton.backgroundColor = Theme.accentColor
        containerView.configureShadowWithCorner(shadowColor: Theme.accentColor, shadowOpacity: 0.8)
        containerView.backgroundColor = Theme.backgroundColor
        layoutTextField(usernameTextFieldView, textFieldView: usernameTextfield, title: StringConstants.username, inputText: "wjohn", tintColorActive: Theme.accentColor)
        layoutTextField(passwordTextFieldView, textFieldView: passwordTextfield, title: StringConstants.password, inputText: "1234", tintColorActive: Theme.accentColor, isSecureTextEntry: true)
    }
    
    private func layoutTextField(_ baseView: UIView, textFieldView: CustomTextFieldView, title: String, inputText: String = "", tintColorActive: UIColor = Theme.accentColor, primaryBorderColour: UIColor = Theme.primaryTextColor.withAlphaComponent(0.8), primaryBackgroundColor: UIColor = Theme.backgroundColor, isSecureTextEntry: Bool = false) {
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
            MessageView.show("Username or Password cannot be empty")
        }
    }
    
    private func authenticateUser(_ sender: LoadingButton, with username: String, for password: String) {
        sender.startLoadingAnimation()
        dispatchGroup.enter()
        HttpUtil.getHttpServiceForAPI("https://run.mocky.io/v3/aaf97364-eedc-46a5-8f9e-56eb4b3cedd2") { [weak self] json in
            if let data = json as? [String: Any] {
                CoreModel.shared.userModel = UserModel(username: data["username"] as? String, firstname: data["firstname"] as? String, lastName: data["lastName"] as? String, dob: data["dob"] as? String, address: data["address"] as? String, pointsEarned: data["pointsEarned"] as? String, walletBalance: data["walletBalance"] as? String)
            }
            self?.dispatchGroup.leave()
        } onFailure: { [weak self] error in
            MessageView.show(error?.localizedDescription ?? "Invalid URL")
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            sender.stopLoadingAnimation()
            if CoreModel.shared.userModel?.username?.equalsIgnoreCase(username) == false || password.equalsIgnoreCase("1234") == false {
                MessageView.show("The user name or password is incorrect")
                CoreModel.shared.userModel = nil
            } else {
                self?.navigateToHomeVC()
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

