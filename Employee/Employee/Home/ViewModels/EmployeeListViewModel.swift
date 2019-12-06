//
//  EmployeeListViewModel.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import Foundation

protocol FullNameDisplayble {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var fullName: String? { get }
}

extension FullNameDisplayble {
    
    var fullName: String? {
        var name: String = ""
        if let value = self.firstName {
            name = value
        }
        if let value = self.lastName {
            if name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                name = name + " " + value
            } else {
                name = self.lastName ?? ""
            }
        }
        return name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 ? name : nil
    }
}

protocol EmployeeDisplayble {
    
    var fullName: String? { get }
    var email: String? { get }
    var imageURL: URL? { get }
    var id: String { get }
}

class EmployeeListViewModel: NSObject {
    
    private var employeeData: EmployeeDataContainer? {
        didSet {
            self.employeeList = self.employeeData?.data ?? []
            self.refresh?()
        }
    }
    var employeeList = [EmployeeDisplayble]()
    
    func numberOfRowsInSection(section: Int = 0) -> Int {
        return self.employeeList.count
    }
    
    var refresh: (() -> Void)?
    
    func getCellViewModel(indexPath: IndexPath) -> EmployeeCellViewModel {
        
        let employee = self.employeeList[indexPath.row]
        return EmployeeCellViewModel(employee: employee)
        
    }
}

extension EmployeeListViewModel {
    
    func fetchData()  {
        let apiRequest = APIRequest(endPoint: Employee.Router.users, method: .get)
        NetworkSessionManager.default.sendRequest(request: apiRequest, response: EmployeeDataContainer.self) { (response) in
            switch response {
            case .success(let container):
                self.employeeData = container
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
