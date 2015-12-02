//
//  QuestaoMenuControllerTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class QuestaoMenuControllerTableViewController: UITableViewController {
    
    private var questaoSelecionada = NSObject()
    private var parseManager = ParseManager.singleton
    private var questoesManager = QuestoesManager.singleton
    var myArray: [PFObject] = []
    private var auxData = AuxiliarQuestoes.singleton
    private var firstTime = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getQuestoes()
        self.configTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
//    MARK: Config
    func configTable(){
        tableView.sectionHeaderHeight = 0.0;
        tableView.sectionFooterHeight = 0.0;
        
        let frame = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = frame
        
        let sfondo = UIImage(named:"Table")
        self.view.backgroundColor = UIColor(patternImage: sfondo!)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        
        self.tableView.headerViewForSection(0)?.backgroundColor? = UIColor.blueColor()
    }
    
    func getQuestoes(){
        
        self.respostasQuestoes(self.myArray)
        
        //        self.myArray = (parseManager.getLeastRatedQuestions())
        self.auxData.questao = self.myArray[0] as AnyObject as! NSObject
        //        questoesManager.tamanhoDasQuestoes(self.myArray.count)
        //
    }
    
// MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myArray.count + 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("questaoCell", forIndexPath: indexPath) as! QuestaoMenuTableViewCell
   
        cell.labelQuestao.font = UIFont (name: "Avenir light", size: 18)
        
        if(self.firstTime){
            if(indexPath.row == myArray.count ){
                self.firstTime = false
            }
            
            let sfondo = UIImage(named:"blue_sky")
            cell.backgroundColor = UIColor(patternImage: sfondo!)
        
            let blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = cell.bounds
        
            cell.insertSubview(blurView, atIndex: 0)
        }
        
        if(indexPath.row == 0){
            cell.labelQuestao.text =  "Finalizar"
            cell.labelQuestao.textColor = UIColor.redColor()
        }else{
            cell.labelQuestao!.text =  "Questão \(indexPath.row)"
            cell.labelQuestao!.textColor = UIColor.whiteColor()
            
            if(self.auxData.arrayQuestoesVerficadas[indexPath.row] == true){
                cell.imgMarker.image = UIImage(named: "Checkmark-100")
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if(indexPath.row == 0){
            let view = self.storyboard?.instantiateViewControllerWithIdentifier("NavResultadoViewController") as! CustomNavigationViewController
            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            self.presentViewController(view, animated: true, completion: nil)
            return
        }
        else{
            self.questaoSelecionada = self.myArray[indexPath.row - 1]
            self.auxData.questao = self.questaoSelecionada
            self.auxData.flag = true
            
            let questaoTemp = self.myArray[indexPath.row - 1]
            self.auxData.objectId = questaoTemp.objectId!
            self.auxData.indexQuestaoSelecionada = indexPath.row
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func respostasQuestoes(enunciados: NSArray){
        
        let arrayRepostas = NSMutableArray()
        
        for x in self.myArray{
            arrayRepostas.addObject(x)
        }
        
        self.auxData.getArrayRespostas(arrayRepostas)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
}
