//
//  MenuTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 14/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Menu"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let img = UIImage(named: "Blurry4")
        self.view.backgroundColor = UIColor(patternImage: img!);
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
