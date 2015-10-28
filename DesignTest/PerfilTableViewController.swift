//
//  PerfilTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class PerfilTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @IBAction func willEdit(sender: AnyObject) {
        let isHidden = !(self.navigationController?.toolbar.hidden)!
        self.navigationController?.setToolbarHidden(isHidden, animated: true)
    }
}
