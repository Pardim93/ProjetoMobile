//
//  VerAlternativasTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class VerAlternativasTableViewController: UITableViewController {
    
    var questao: PFObject?
    private var arrayAlternativas = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false;
        self.carregaQuestao()
        
        self.tableView.tableHeaderView = nil
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.configNavBarHidingCells()
        self.configTabbarHidingCells()
    }
    
//    MARK: Config
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 60))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 50))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
    func carregaQuestao(){
        for index in 0...4{
            let letter = LetraAlternativa(rawValue: index)
            let newValue = "Alternativa\(letter!)"
            
            let newAlternativa = questao?.objectForKey(newValue) as? String
            
            self.arrayAlternativas.addObject(newAlternativa!)
        }
    }
    
//    MARK: TableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exercicioCell") as! PerguntasTableViewCell
        cell.textViewResposta.text = arrayAlternativas[indexPath.row] as? String
        
        cell.labelResposta.text = (String( UnicodeScalar ( 65 + indexPath.row)))

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
