//
//  ViewController.swift
//

import UIKit

class LaunchAnimationViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: StringConstants.logo)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoImageView)
        view.backgroundColor = Theme.backgroundColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoImageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateLogo()
        }
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.logoImageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        }
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            self?.logoImageView.alpha = 0
        } completion: { [weak self] didComplete in
            if didComplete {
                let vc = AuthViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.present(vc, animated: true)
                }
            }
        }
    }

}

