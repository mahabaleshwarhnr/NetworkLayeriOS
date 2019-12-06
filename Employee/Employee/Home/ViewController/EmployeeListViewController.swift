//
//  EmployeeListViewController.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        return activityIndicator
    }()
    
    let cellIdentifier = "EmployeeTableViewCell"

    lazy var viewModel: EmployeeListViewModel = {
        return EmployeeListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(activityIndicator)
        self.activityIndicator.isHidden = true
        self.activityIndicator.startAnimating()
        self.tableView.tableFooterView = UIView()
        self.viewModel.refresh = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
        self.viewModel.fetchData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension EmployeeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.employeeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EmployeeTableViewCell
        cell.viewModel = self.viewModel.getCellViewModel(indexPath: indexPath)
        return cell
        
    }
}
