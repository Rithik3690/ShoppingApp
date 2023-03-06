//
//  UIImageView.swift
//  

import UIKit

extension UIImageView {
        
    func loadImageFromAPI(with url: String?) {
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = url else { return }
        let imageCache = NSCache<NSString, UIImage>()
        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            image = imageFromCache
            return
        }
        
        guard let request = RouterRequest.getUrlRequest(url, method: .GET) else {
            MessageView.show(App.StringConstants.url_error)
            return
        }
        
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
