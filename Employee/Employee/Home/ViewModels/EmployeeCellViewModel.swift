//
//  EmployeeCellViewModel.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation



struct EmployeeCellViewModel {
    
    var name: String?
    var email: String?
    var avatar: URL?
    
    init(employee: EmployeeDisplayble) {
        self.name = employee.fullName
        self.email = employee.email
        self.avatar = employee.imageURL
    }
    
}
