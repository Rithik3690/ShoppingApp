//
//  HttpUtil.swift
//

import UIKit

public class HttpUtil {
    public static func getHttpServiceForAPI(_ url: String, onSuccess success: @escaping (_ json: Any?) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: url) else {
            failure(NSError(domain: "Invalid URL", code: 500))
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Double.infinity)
        request.httpMethod = StringConstants.get
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data, error == nil else {
                failure(error)
                return
            }
            do {
                let requiredData = try JSONSerialization.jsonObject(with: data)
                success(requiredData)
            } catch {
                failure(error)
            }
        }
        task.resume()
    }
}
