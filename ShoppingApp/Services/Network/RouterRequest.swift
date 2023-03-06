//
//  RouterRequest.swift
//  

import Foundation

protocol RouterRequestProtocol {
    static func getUrlRequest(_ url: String, method: RouterMethod) -> URLRequest?
}

struct RouterRequest: RouterRequestProtocol {
    static func getUrlRequest(_ url: String, method: RouterMethod) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        switch method {
        case .GET:
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Double.infinity)
            request.httpMethod = method.rawValue
            return request
        case .POST:
            break
        case .PUT:
            break
        case .DELETE:
            break
        }
        return nil
    }
}
