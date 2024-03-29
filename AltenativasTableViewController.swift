//
//  AltenativasTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit



class AltenativasTableViewController: UITableViewController , CustomTextViewDelegate{
    
    
    let questoesManager = QuestoesManager.singleton
    
    var arrayAlternativas = NSMutableArray()
    var questao = NSObject()
    var auxData = AuxiliarQuestoes.singleton
    var outraArray = NSMutableArray()
    var countLetras = 65
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
     
    }
    
    //    MARK: Configuration
    func configView(){
        self.countLetras = 65
        self.automaticallyAdjustsScrollViewInsets = false
        self.getAlternativas(self.questao)
        self.carregaQuestao()
    }
    
    
    
    func configTableView(){
        tableView.sectionHeaderHeight = 0.0;
        tableView.sectionFooterHeight = 0.0;
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.tableView.reloadData()
        self.iterateCells()
        self.configView()
        
        if(auxData.indexAlternativa != -1){
            marcaCorreta(auxData.indexAlternativa)
        }
        
    }
    
    
    //  MARK: - Questao
    func getAlternativas(obj:NSObject){
        for index in 65...69{
            let letra = String(UnicodeScalar(index))
            outraArray.addObject(questao.valueForKey("Alternativa\(letra)")!)
        }
    }
    
    func carregaQuestao(){
        while(arrayAlternativas.count < 5){
            let  rndNum = Int(arc4random_uniform(5))
            
            if(!arrayAlternativas.containsObject((self.outraArray[rndNum]))){
                arrayAlternativas.addObject((self.outraArray[rndNum]))
            }
            
        }
    }
    
    func marcaCorreta(row: Int){
        self.auxData.questaoSelecionada = self.arrayAlternativas[row] as! String
        self.auxData.indexAlternativa = row 
        questoesManager.addRepostaNoIndex(self.auxData.questaoSelecionada, index:self.auxData.indexQuestaoSelecionada - 1)
        
        self.iterateCells()
        auxData.arrayQuestoesVerficadas[auxData.indexQuestaoSelecionada]  = true
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PerguntasTableViewCell
        cell.setAsResposta()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 111
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAlternativas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PerguntasTableViewCell
        
        cell.texto.customDelegate = self
        cell.texto.cellRow = indexPath.row
        cell.texto.sizeToFit()
        cell.texto.layoutIfNeeded()
        cell.LETRA.textColor = UIColor.blackColor()
        cell.texto.text = self.arrayAlternativas[indexPath.row] as! String
        
        if(countLetras <= 69){
            let letra = String(UnicodeScalar(countLetras))
            cell.LETRA.text = letra
            countLetras++
        }
        
        cell.texto.font = UIFont (name: "Avenir book", size: 18)
        cell.texto.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.marcaCorreta(indexPath.row)
        
    }
    
    func iterateCells(){
        for x in 0...self.arrayAlternativas.count - 1{
            let  cellPath = NSIndexPath(forRow: x, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(cellPath) as! PerguntasTableViewCell
            cell.setAsNormal()
        }
    }
    
    // MARK: -Delegate
    func finishEdit(cellRow: Int) {
        self.marcaCorreta(cellRow)
    }
}
