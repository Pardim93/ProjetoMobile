//
//  LicensasTableViewController.swift
//  Vestibulandos
//
//  Created by Andre Lucas Ota on 02/12/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class LicensasTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
    }
    
//    MARK: Config
    func configTableView(){
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }

// MARK: - Table view data source

    
//    MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! SobreViewController
        
        nextView.configuration = segue.identifier!
    }
}
