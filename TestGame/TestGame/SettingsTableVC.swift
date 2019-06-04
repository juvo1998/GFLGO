//
//  SettingsTableVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingsTableVC: viewDidLoad()")
        
        // Remove the lines of empty cells
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        if indexPath.row == 2 {
            // performSegue(withIdentifier: "LoginSegue", sender: self)
            self.navigationController?.popViewController(animated: true)
        }
         */
        
        switch indexPath.row {
        case 1:
            print("change password")
        case 2:
            self.navigationController?.popViewController(animated: true)
        default:
            print("switch default")
        }
    }
}
