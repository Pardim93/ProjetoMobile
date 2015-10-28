//
//  TrocarInfoTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol TrocarUserInfoDelegate{
    func setNewValue(changeKey: String, newOpcao: String)
}

class TrocarInfoTableViewController: UITableViewController {
    
    var oldOpcao: String = ""
    var arrayInfo: [String] = []
    var changeKey: String = ""
    var delegate: TrocarUserInfoDelegate?
    var selectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.selectCellWithOpcao(oldOpcao)
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.selectCellWithOpcao(oldOpcao)
//    }
    
//    MARK: Config
    func selectCellWithOpcao(opcao: String){
        for index in 0...arrayInfo.count{
            if (arrayInfo[index] == opcao){
                selectedRow = index
                
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)

                break
            }
        }
    }
    
    func configTableView(){
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }
    
// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayInfo.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("opcaoCell", forIndexPath: indexPath) as! AjustesTableViewCell
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.setOpcao(arrayInfo[indexPath.row])
        
//        if(arrayInfo[indexPath.row] == self.oldOpcao){
////            cell.createCheck()
//            let a = arrayInfo[indexPath.row]
//            print(a)
//        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        guard let oldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0)) as? AjustesTableViewCell else{
//            return
//        }
        
//        oldCell.removeCheck()
//        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? AjustesTableViewCell else{
            return
        }
//
//        selectedRow = indexPath.row
//        cell.createCheck()
        
        self.delegate?.setNewValue(self.changeKey, newOpcao: cell.getOpcao())
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
