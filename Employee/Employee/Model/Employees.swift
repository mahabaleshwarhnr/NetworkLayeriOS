//
//  Employees.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation

// MARK: - EmployeeDataContainer
struct EmployeeDataContainer: Codable {
    let page, perPage, total, totalPages: Int?
    let data: [Employee]?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}

// MARK: - Datum
struct Employee: Codable {
    let empId: Int?
    var email, firstName, lastName: String?
    let avatar: URL?

    enum CodingKeys: String, CodingKey {
        case empId = "id"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}


extension Employee: EmployeeDisplayble, FullNameDisplayble {    
    
    var id: String {
        return self.empId!.description
    }
    var imageURL: URL? {
        return self.avatar
    }
}

extension Employee {
    
    enum Router: APIEndPoint {
        case users
        
        var value: String {
            return "users"
        }
    }
}
