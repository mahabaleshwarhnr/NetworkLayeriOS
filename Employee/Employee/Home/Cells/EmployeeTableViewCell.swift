//
//  EmployeeTableViewCell.swift
//  Employee
//
//  Created by mahabaleshwar hegde on 03/12/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    var viewModel: EmployeeCellViewModel? {
        didSet {
            self.textLabel?.text = self.viewModel?.name
            self.detailTextLabel?.text = self.viewModel?.email
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
