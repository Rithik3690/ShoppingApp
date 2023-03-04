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

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.animationStyle = .springIn
        containerView.configureShadowWithCorner(shadowColor: .getColorFromHex("EC6296"), shadowOpacity: 0.8)
        layoutTextField(usernameTextFieldView, textFieldView: usernameTextfield, title: StringConstants.username, inputText: "JWick", tintColorActive: .getColorFromHex("EC6296"))
        layoutTextField(passwordTextFieldView, textFieldView: passwordTextfield, title: StringConstants.password, tintColorActive: .getColorFromHex("EC6296"), isSecureTextEntry: true)
    }
    
    private func layoutTextField(_ baseView: UIView, textFieldView: CustomTextFieldView, title: String, inputText: String = "", tintColorActive: UIColor = .systemBlue, primaryBorderColour: UIColor = .systemGray, primaryBackgroundColor: UIColor = .systemBackground, isSecureTextEntry: Bool = false) {
        baseView.addSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: baseView.leadingAnchor, multiplier: 2),
            baseView.trailingAnchor.constraint(equalToSystemSpacingAfter: textFieldView.trailingAnchor, multiplier: 2),
        ])
        textFieldView.configureTextField(title, inputText: inputText, tintColorActive: tintColorActive, primaryBorderColour: primaryBorderColour, primaryBackgroundColor: primaryBackgroundColor, isSecureTextEntry: isSecureTextEntry)
    }
    
    @IBAction func signInPressed(_ sender: LoadingButton) {
        sender.startLoadingAnimation()
        if usernameTextfield.textField.text == "" || passwordTextfield.textField.text == "" {
            MessageView.show("Username or Password cannot be empty")
            sender.stopLoadingAnimation()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sender.stopLoadingAnimation()
            if self.usernameTextfield.textField.text != "wjohn" {
                MessageView.show("Invalid Username")
                return
            }
            
            if self.passwordTextfield.textField.text != "1234" {
                MessageView.show("The user name or password is incorrect")
                return
            }
            self.createAndNavigateToTabBarVC()
        }
    }
    
    private func createAndNavigateToTabBarVC() {
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = .systemBackground
        tabBarVC.tabBar.sizeToFit()
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.title = StringConstants.home
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.title = StringConstants.profile
        let imageNames: [String] = [StringConstants.house, StringConstants.person]
        let selectedImageNames: [String] = [StringConstants.house_fill, StringConstants.person_fill]
        tabBarVC.setViewControllers([homeVC, profileVC], animated: false)

        guard let tabBarItems = tabBarVC.tabBar.items else { return }
        for index in 0..<tabBarItems.count {
            tabBarItems[index].image = UIImage(systemName: imageNames[index])
            tabBarItems[index].selectedImage = UIImage(systemName: selectedImageNames[index])
            UITabBar.appearance().tintColor = UIColor.getColorFromHex("EC6296")
        }
        tabBarVC.modalTransitionStyle = .crossDissolve
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}

