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
//        self.tagsTextView.enableScroll = true
        self.tagsTextView.scrollEnabled = true
        self.tagsTextView.limitChar = 400
//        self.tagsTextView.limitHeight = 120
        self.tagsTextView.placeholder = "Palavras chave. Separe-as com ,"
    }
    
    func configDescricaoCell(){
//        self.descricaoTextView.enableScroll = true
        self.descricaoTextView.scrollEnabled = true
        self.descricaoTextView.limitChar = 400
//        self.descricaoTextView.limitHeightEnable = false
//        self.descricaoTextView.limitHeight = self.descricaoTextView.frame.height
        self.descricaoTextView.placeholder = "Descrição da Prova"
    }
    
//    MARK: Get
    func getDescricao() -> String{
        return self.descricaoTextView.text!
    }
    
    func getTags() -> [String]{
        var auxArray: [String] = []
        
        let auxText = self.tagsTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let arrayTag = auxText.componentsSeparatedByString(",")
        
        for palavraChave in arrayTag{
            auxArray.append(palavraChave.simpleString())
        }
        
        return auxArray
    }
    
//    MARK: TableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
//    MARK: Check
    func checkDescricao() -> Bool{
        guard let text = self.descricaoTextView.text else{
            descricaoTextView.makeRed()
            return false
        }
        
        if(descricaoTextView.placeHolderActive){
            descricaoTextView.makeRed()
            return false
        }
        
        if (text.characters.count < 5){
            descricaoTextView.makeRed()
            return false
        }
        
        if(!text.hasLetter()){
            descricaoTextView.makeRed()
            return false
        }
        
        descricaoTextView.makeBlack()
        return true
    }
    
    func checkTags() -> Bool{
        if(self.tagsTextView.placeHolderActive){
            self.tagsTextView.makeRed()
            return false
        }
        
        guard let text = self.tagsTextView.text else{
            self.tagsTextView.makeRed()
            return false
        }
        
        if(!text.hasLetter()){
            self.tagsTextView.makeRed()
            return false
        }
        
        let auxText = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let arrayTag = auxText.componentsSeparatedByString(",")
        
        for palavraChave in arrayTag{
            if(!palavraChave.hasLetter()){
                self.tagsTextView.makeRed()
                return false
            }
            
            if(palavraChave.characters.count < 1){
                self.tagsTextView.makeRed()
                return false
            }
        }
        
        self.tagsTextView.makeBlack()
        return true
    }
}
