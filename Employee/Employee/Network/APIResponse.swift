//
//  APIResponse.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 04/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation

protocol Response: ResponsModelConvertible {
    func sendRequest<Response: Decodable, Request: APIRequestInitializable>(request: Request,response: Response.Type, completionHandler: @escaping CompletionHandler<Response, Error>) -> URLSessionTask
}

extension Response {
    
    @discardableResult
       func sendRequest<Response: Decodable, Request: APIRequestInitializable>(request: Request,response: Response.Type, completionHandler: @escaping CompletionHandler<Response, Error>) -> URLSessionTask {
           
           
           let task = NetworkSessionManager.default.session.dataTask(with: request.urlRequest) { (data, urlResponse, error) in
               guard urlResponse?.isSuccess == true, let responseData = data else {
                   completionHandler(Result.failure(error!))
                   return
               }
               do {
                   let model = try self.parse(response: response, data: responseData)
                   completionHandler(Result.success(model))
               } catch let paseError {
                   completionHandler(Result.failure(paseError))
               }
           }
           
           task.resume()
           return task
       }
}
