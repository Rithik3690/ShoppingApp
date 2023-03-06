//
//  HttpUtil.swift
//

import UIKit

protocol RouterProtocol {
    static func getHttpServiceForAPI(_ url: String, onSuccess success: @escaping RouterSuccessResponse, onFailure failure: @escaping RouterFailureResponse)
}

public class Router: RouterProtocol {
    public static func getHttpServiceForAPI(_ url: String, onSuccess success: @escaping RouterSuccessResponse, onFailure failure: @escaping RouterFailureResponse) {
        guard let request = RouterRequest.getUrlRequest(url, method: .GET) else {
            failure(NSError(domain: App.StringConstants.url_error, code: 500))
            return
        }
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
