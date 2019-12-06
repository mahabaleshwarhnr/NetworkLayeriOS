//
//  NetworkSessionManager.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 04/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation


protocol NetworkSessionConfigurable {
    var session: URLSession { get  }
    init(session: URLSession)
}

extension NetworkSessionConfigurable {
    var session: URLSession {
        return URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }
}

class NetworkSessionManager: NetworkSessionConfigurable, Response {
    
    
    private let accessToken: String = "b03a7f738c9b4d958028e277114dcb9d"
    static let `default`: NetworkSessionManager = NetworkSessionManager(session: URLSession(configuration: .default, delegate: nil, delegateQueue: .main))
    
    private(set) var session: URLSession
    
    required init(session: URLSession) {
        self.session = session
    }
}
