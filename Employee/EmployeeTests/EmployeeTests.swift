//
//  EmployeeTests.swift
//  EmployeeTests
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import XCTest
@testable import Employee

class EmployeeTests: XCTestCase {
    
    private var viewModel: EmployeeListViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = EmployeeListViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
    }
    
    func testEmployeeFullNameSuccess() {
        
        let employee = Employee(empId: 2, email: "michael.lawson@reqres.in", firstName: "Michael", lastName: "Lawson", avatar: nil)
        XCTAssertEqual(employee.fullName, "Michael Lawson")
    }
    
    func testEmployeeFullNameWithoutLastNameSuccess() {
        
        let employee = Employee(empId: 2, email: "michael.lawson@reqres.in", firstName: "Michael", lastName: nil, avatar: nil)
        XCTAssertEqual(employee.fullName, "Michael")
    }
    
    func testEmployeeFullNameWithoutFirstNameSuccess() {
        
        let employee = Employee(empId: 2, email: "michael.lawson@reqres.in", firstName: nil, lastName: "Lawson", avatar: nil)
        XCTAssertEqual(employee.fullName, "Lawson")
    }
    
    func testEmployeeFullNameNil() {
        
        let employee = Employee(empId: 2, email: "michael.lawson@reqres.in", firstName: nil, lastName: nil, avatar: nil)
        XCTAssertNil(employee.fullName)
    }
    
    
    func testUsersEndpointAPI()  {
        
        viewModel.fetchData()
    }

}
