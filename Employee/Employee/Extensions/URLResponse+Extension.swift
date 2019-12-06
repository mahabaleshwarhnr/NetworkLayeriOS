//
//  URLResponse+Extension.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 04/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation


extension URLResponse {
    var httpStatusCode: Int? {
        guard let httpResponse = self as? HTTPURLResponse else {
            return nil
        }
        return httpResponse.statusCode
    }

    var isSuccess: Bool {
        guard let value = self.httpStatusCode else {
            return false
        }
        switch value {
        case 200 ... 299:
            return true
        default:
            return false
        }
    }
}
