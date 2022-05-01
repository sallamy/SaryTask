//
//  APIRouter.swift
//  Task
//
//  Created by mohamed salah
//

import Foundation
import Alamofire


protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}

struct Constants {
    struct ProductionServer {
        static let baseURL = "https://staging.sary.to/api/v2.5.1/baskets/325514/"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case Platform = "Platform"
    case Accept_Language = "Accept-Language"
    case App_Version = "App-Version"
    case Device_Type = "Device-Type"
    
    var headerValue: String {
        switch self {
        case .authentication:
            return "token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MjgxNTEyLCJ1c2VyX3Bob25lIjoiOTY2NTkxMTIyMzM0In0.phRQP0e5yQrCVfZiN4YlkI8NhXRyqa1fGRx5rvrEv0o"
        case .Platform:
            return "FLAGSHIP"
        case .Accept_Language:
            return "ar"
        case .App_Version:
            return "5.5.0.0.0"
        case .Device_Type:
            return "ios"
        }
    }
    
}

enum ContentType: String {
    case json = "application/json"
    case formEncode = "application/x-www-form-urlencoded"
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
}


enum APIRouter: APIConfiguration {
    
    case getBanners
     case getCatalog
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getBanners,.getCatalog:
            return .get
        }
    }
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
       
        case .getBanners,.getCatalog:
            return .url([:])
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getBanners:
            return "/banners"
        case .getCatalog:
            return "/catalog"
       
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.setValue(HTTPHeaderField.Platform.headerValue, forHTTPHeaderField: HTTPHeaderField.Platform.rawValue)
        urlRequest.setValue(HTTPHeaderField.authentication.headerValue, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        urlRequest.setValue(HTTPHeaderField.Device_Type.headerValue, forHTTPHeaderField: HTTPHeaderField.Device_Type.rawValue)
        urlRequest.setValue(HTTPHeaderField.Accept_Language.headerValue, forHTTPHeaderField: HTTPHeaderField.Accept_Language.rawValue)
        urlRequest.setValue(HTTPHeaderField.App_Version.headerValue, forHTTPHeaderField: HTTPHeaderField.App_Version.rawValue)
     
        
        // Parameters
        switch parameters {
        
        case .body(let params):
            
            urlRequest.httpBody =  try! JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
}


