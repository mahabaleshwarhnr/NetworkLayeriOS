//
//  APIRequest.swift
//  MVVMExample
//
//  Created by mahabaleshwar hegde on 27/11/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndPoint {
     var value: String { get }
}

typealias CompletionHandler<SucessResponse, ErrorResponse: Error> = (_ result: Result<SucessResponse, ErrorResponse>) -> Void

protocol URLBuilder {
    var baseURL: URL { get }
    var endPoint: String { get }
    var queryParams: [String: String]? { get }
    func getURL() -> URL
}

protocol URLRequestInitializable: URLBuilder {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get set }
    associatedtype Payload
    var payload: Payload? { get }
    var urlRequest: URLRequest { get }
}



protocol PayloadEncodable: Encodable {
    func toEncodedData() -> Data?
}

extension PayloadEncodable {
     
    func toEncodedData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}


protocol APIRequestInitializable: URLRequestInitializable, JsonPayloadEncodable {
    

    init(endPoint: APIEndPoint, method: HTTPMethod, payload: Payload?, queryParams: [String: String]?)
}

class APIRequest: APIRequestInitializable {
    
    typealias Payload = PayloadEncodable
    
    var headers: [String : String]?
    var method: HTTPMethod
    var payload: PayloadEncodable?
    var endPoint: String
    var queryParams: [String : String]?
    
    required init(endPoint: APIEndPoint, method: HTTPMethod = .get, payload: Payload? = nil, queryParams: [String : String]? = nil) {
        self.headers = queryParams
        self.method = method
        self.payload = payload
        self.endPoint = endPoint.value
    }
}

extension URLBuilder {
    
    var baseURL: URL {
        return URL(string: "https://reqres.in/api/")!
    }
    
    func getURL() -> URL {
        let url = URL(string: self.endPoint, relativeTo: baseURL)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = self.queryParams?.map(URLQueryItem.init)
        return components.url!
    }
}



extension URLRequestInitializable {
    
    var headers: [String : String]? {
        switch self.method {
        case .post:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.getURL())
        request.httpMethod = self.method.rawValue
        guard let body = self.payload else {
            return request
        }
        var data: Data?
        switch body {
        case (is PayloadEncodable):
            let value = body as! PayloadEncodable
            data = value.toEncodedData()
        default:
            data = try? JSONSerialization.data(withJSONObject: body, options: .init(rawValue: 0))
        }
        request.httpBody = data
        return request
    }
}

extension APIRequestInitializable {
    
    func getURLRequest<T>(_ payload: T?) throws -> URLRequest where T : Encodable {
        
        var request = URLRequest(url: self.getURL())
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = [:]
        if let value = payload {
            request.httpBody = try? self.encode(value)
        }
        return request
    }
}


typealias JsonParsable = JsonPayloadEncodable & ResponsModelConvertible

protocol JsonPayloadEncodable {
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

protocol ResponsModelConvertible {
    func parse<T: Decodable>(response: T.Type, data: Data) throws  -> T
}

extension JsonPayloadEncodable {
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(value)
        return data
    }
}

extension ResponsModelConvertible  {
    
    func parse<T: Decodable>(response: T.Type, data: Data) throws -> T {
        print(data.prettyPrintedJSONString as Any)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let responseModel = try jsonDecoder.decode(response, from: data)
        return responseModel
    }
}

protocol ImageDownloadable {
    
    func downloadImage(url: URL, completionHandler: @escaping CompletionHandler<UIImage, Error>) -> URLSessionTask
}


extension ImageDownloadable {
    
    
    @discardableResult
    func downloadImage(url: URL, completionHandler: @escaping CompletionHandler<UIImage, Error>) -> URLSessionTask {
        
        let urlRequest = URLRequest(url: url)
        let task = NetworkSessionManager.default.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let responseData = data else {
                completionHandler(Result.failure(error!))
                return
            }
            guard let image = UIImage(data: responseData) else {
                completionHandler(Result.failure(NSError(domain: "data error", code: 1000, userInfo: nil)))
                return
            }
            completionHandler(Result.success(image))
        }
        task.resume()
        return task
    }
}
