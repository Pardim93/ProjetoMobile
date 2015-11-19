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
    private var myArray = NSArray()
    private var auxData = AuxiliarQuestoes.singleton
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getQuestoes()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        if(indexPath.row > 0 ){
            
            self.questaoSelecionada = self.myArray.objectAtIndex(indexPath.row - 1) as! NSObject
            self.auxData.questao = self.questaoSelecionada
            self.auxData.flag = true
            let questaoTemp = self.myArray.objectAtIndex(indexPath.row - 1) as! PFObject
            self.auxData.objectId = questaoTemp.objectId!
            self.auxData.indexQuestaoSelecionada = indexPath.row
        }else{
            
            let view = self.storyboard?.instantiateViewControllerWithIdentifier("NavResultadoViewController")
    
            
            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            self.presentViewController(view!, animated: false, completion: nil)
            
            
            
            //            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            
            //            self.presentViewController(view, animated: false, completion: nil)
            //            self.performSegueWithIdentifier("rrr", sender: self.questaoSelecionada)
        }
        //        self.performSegueWithIdentifier("sw_front", sender: self)
        
        //já há uma segue configurada no storybard
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
        
        //        if indexPath.row == 0{
        //            cell.textLabel?.text = "Sair"
        //        }else{
        //
        
        
        if(indexPath.row == 0){
            
            cell.labelQuestao.text =  "Finalizar"
            
        }else{
            cell.labelQuestao!.text =  self.myArray.objectAtIndex(indexPath.row - 1).objectForKey("Enunciado") as? String
            
            
            
            
        }
        //        }
        // Configure the cell...
        
        
        return cell
    }
    
    func getQuestoes(){
        self.myArray = (parseManager.getLeastRatedQuestions())
        self.auxData.questao = self.myArray.objectAtIndex(0) as AnyObject as! NSObject
        questoesManager.tamanhoDasQuestoes(self.myArray.count)
        self.respostasQuestoes(self.myArray)
        
    }
    
    
    func respostasQuestoes(enunciados: NSArray){
        
        let arrayRepostas = NSMutableArray()
        
        for x in self.myArray{
            arrayRepostas.addObject(x)
            //            print(x.valueForKey("AlternativaA"))
        }
        
        self.auxData.getArrayRespostas(arrayRepostas)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == .Delete {
    //            // Delete the row from the data source
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //        } else if editingStyle == .Insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "rrr"){
            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            
            
        }
        
    }
    
}
