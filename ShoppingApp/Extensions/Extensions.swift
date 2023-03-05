//
//  Extensions.swift
//

import UIKit

extension UIView {
    func configureShadowWithBorderAndCorner(withBorder borderWidth: CGFloat = 0.5, borderColor: UIColor = .systemGray, cornerRadius: CGFloat = 6.0, shadowColor: UIColor = .systemGray, shadowOpacity: Float = 0.54, shadowRadius: CGFloat = 3.0, shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5)) {
        layer.masksToBounds = false
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    func configureShadowWithCorner(withCorner cornerRadius: CGFloat = 6.0, shadowColor: UIColor = .systemGray, shadowOpacity: Float = 0.54, shadowRadius: CGFloat = 3.0, shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5)) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
}

public extension UIDevice {
    class var isIpad: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}


extension String {
    func equalsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased() == string.lowercased()
    }
}

extension UIImageView {
        
    func loadImageFromAPI(with url: String?) {
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = url, let apiUrl = URL(string: url) else { return }
        let imageCache = NSCache<NSString, UIImage>()
        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            image = imageFromCache
            return
        }
        
        var request = URLRequest(url: apiUrl,timeoutInterval: Double.infinity)
        request.httpMethod = StringConstants.get
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: url as NSString)
                    self?.image = image
                }
            }
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
