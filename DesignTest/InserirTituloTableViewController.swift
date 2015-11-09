//
//  InserirTituloTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirTituloTableViewController: UITableViewController{
    
    var arrayCell = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.translucent = false
        self.configTabbarHidingCells()
        self.configNavBarHidingCells()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.configBackButton()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }

//    MARK: Config
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 30))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 50))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
//    MARK: TableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let row = indexPath.row
        
        if (row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("tituloCell", forIndexPath: indexPath) as! TituloTableViewCell
        } else{
            if (row == 1){
                cell = tableView.dequeueReusableCellWithIdentifier("disciplinaCell", forIndexPath: indexPath) as! DisciplinaTableViewCell
            } else{
                cell = tableView.dequeueReusableCellWithIdentifier("palavrasChaveCell", forIndexPath: indexPath) as! PalavrasChaveTableViewCell
            }
        }
        
        arrayCell.addObject(cell)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        if (row == 0){
            return 160
        } else{
            if (row == 1){
                return 275
            } else{
                return 140
            }
        }
    }
    
//    MARK: CheckConteudo
    func tituloValido() -> Bool{
        guard let tituloCell = self.arrayCell.objectAtIndex(0) as? TituloTableViewCell else{
            return false
        }
        
        return tituloCell.tituloValido()
    }
    
    func palavrasChaveValidas() -> Bool{
        guard let palavrasChaveCell = self.arrayCell.objectAtIndex(2) as? PalavrasChaveTableViewCell else{
            return false
        }
        
        return palavrasChaveCell.palavrasValidas()
    }
    
    func checkDisciplina() -> Bool{
        guard let disciplinaCell = self.arrayCell.objectAtIndex(1) as? DisciplinaTableViewCell else{
            return false
        }
        
        return disciplinaCell.disciplinaValida()
    }
    
//    MARK: Other
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
}
