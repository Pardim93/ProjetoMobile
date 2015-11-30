//
//  InserirExTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 22/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirExTableViewController: UITableViewController {
    
    var arrayCell = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Alternativas"
        self.configureTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBar = self.tabBarController as! InserirExTabBarViewController
        tabBar.configSaveButton()
    }
    
    func configureTableView(){
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        for anyCell in tableView.visibleCells{
            let cell = anyCell
            cell.sizeToFit()
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        self.configTabbarHidingCells()
        self.configNavBarHidingCells()
    }
    
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 40))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 1))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
//    MARK: CheckConteudo
    func alternativaValida() -> Bool{
        if !(arrayCell.count > 0){
            return false
        }
        
        for cell in self.arrayCell{
            guard let inserirCell = cell as? InserirExTableViewCell else{
                print("Erro em InserirExTableViewController")
                return false
            }
            
            if (!inserirCell.respostaValida()){
                return false
            }
        }
        
        return true
    }
    
//    MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alternativaCell", forIndexPath: indexPath) as! InserirExTableViewCell
        
        let letter = LetraAlternativa(rawValue: indexPath.row)
        cell.altLabel.text = "\(letter!)"
        cell.textView.limitChar = 140
        cell.textView.limitHeight = 110
        if(indexPath.row == 0){
            cell.textView.placeholder = "Alternativa Correta"
            cell.altLabel.textColor = UIColor.greenColor()
        } else{
            cell.textView.placeholder = "Alternativa Errada"
            cell.altLabel.textColor = UIColor.redColor()
        }
        
        arrayCell.addObject(cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
//    MARK: Return
    func getAlternativas() -> [String]{
        var arrayAlt: [String] = []
        
        for cell in self.arrayCell{
            let altCell = cell as! InserirExTableViewCell
            arrayAlt.append(altCell.textView.text)
        }
        
        return arrayAlt
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//    }
}


