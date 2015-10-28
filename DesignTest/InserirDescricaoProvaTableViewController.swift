//
//  InserirDescricaoProvaTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 22/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirDescricaoProvaTableViewController: UITableViewController {

    @IBOutlet weak var tagsTextView: InserirTextView!
    @IBOutlet weak var descricaoTextView: InserirTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavBarHidingCells()
        self.configTableView()
        self.configTagsCell()
        self.configDescricaoCell()
    }
    
    //    MARK: Config
    func configTableView(){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 30))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
//    MARK: ConfigCells
    func configTagsCell(){
        self.tagsTextView.enableScroll = true
        self.tagsTextView.limitChar = 400
        self.tagsTextView.limitHeight = 120
        self.tagsTextView.placeholder = "Palavras chave. Separe-as com ,"
    }
    
    func configDescricaoCell(){
        self.descricaoTextView.enableScroll = true
        self.descricaoTextView.limitChar = 400
        self.descricaoTextView.limitHeight = self.descricaoTextView.frame.height
        self.descricaoTextView.placeholder = "Descrição da Prova"
    }
    
//    MARK: TableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
}
