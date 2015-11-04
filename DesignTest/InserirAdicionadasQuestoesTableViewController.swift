//
//  InserirAdicionadasQuestoesTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirAdicionadasQuestoesTableViewController: UITableViewController, TratarQuestaoDelegate, CustomTextViewDelegate {
    
    var questoes: [PFObject] = []
    let inserirQuestoesManager = InserirQuestoesProvaManager.singleton

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateQuestoes()
    }
    
//    MARK: Config
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "InserirQuestaoTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
        
        self.configTabbarHidingCells()
        
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 50))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }

//    MARK: Delegate
    func finishEdit(cellRow: Int) {
        self.view.endEditing(true)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false)
        
        guard let newQuestao = questoes[cellRow] as? PFObject else{
            return
        }
        
//        self.prepareGoToQuestao(newQuestao)
    }
    
    func tratarQuestao(questao: PFObject) {
        let oldId = questao.objectId
        for i in 0...self.questoes.count{
            let obj = questoes[i] 
            let newId = obj.objectId
            
            if(newId == oldId){
                inserirQuestoesManager.adicionadas.removeAtIndex(i)
                break
            }
        }
        
        self.updateQuestoes()
    }
    
// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questoes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! InserirQuestaoTableViewCell
        
        let newQuestao = questoes[indexPath.row]
        
        cell.delegate = self
        cell.descricaoTextView.customDelegate = self
        //        cell.questao = newQuestao
        cell.setInfo(newQuestao, newRow: indexPath.row)
        //        cell.descricaoTextView.cellRow = indexPath.row
        
        let adicionadas = inserirQuestoesManager.adicionadas
        
        let actualId = newQuestao.objectId
        for adicionada in adicionadas{
            let oldId = adicionada.objectId
            
            if(oldId == actualId){
                cell.adicionarButton.enabled = false
                break
            }
        }
        
        return cell
    }
    
//    MARK: Update
    func updateQuestoes(){
        self.questoes = inserirQuestoesManager.adicionadas
        self.tableView.reloadData()
    }
    
//    MARK: View
    func enableView(){
        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
    }
    
    func disabeView(){
        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
    }
    
//    MARK: Navigation
    func prepareGoToQuestao(questao: PFObject){
        self.disabeView()
        
        self.inserirQuestoesManager.getImg(questao){(newImg) -> () in
            self.enableView()
//            self.goToQuestao(questao, img: newImg)
        }
    }
}
