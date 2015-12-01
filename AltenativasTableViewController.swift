//
//  AltenativasTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AltenativasTableViewController: UITableViewController {
    //singleton vai ter um nsquestion para a questao temp selecionada
    //a questao tmp, ira ser armazenada em uma array do singleton questoes
    //o usuario ira escolher outra questao
    //prova acabar quando usuario resolve finalizar a prova
    //compara as resposta do usuario na hora
    
    @IBOutlet weak var letraAlternativa: UILabel!
    
    private var arrayAlternativas = NSMutableArray()
    var questao = NSObject()
    var auxData = AuxiliarQuestoes.singleton
    var outraArray = NSMutableArray()
    var questoesManager = QuestoesManager.singleton
    var countLetras = 65
    
    override  func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countLetras = 65
        tableView.sectionHeaderHeight = 0.0;
        tableView.sectionFooterHeight = 0.0;
        tableView.tableFooterView = UIView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.getAlternativas(self.questao)
        self.questao = self.auxData.questao
        self.carregaQuestao()
        
        
        //        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    //  override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    override func viewDidDisappear(animated: Bool) {
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayAlternativas.count
    }
    
    
    func getAlternativas(obj:NSObject){
        
        
        for index in 65...69{
            let letra = String(UnicodeScalar(index))
            outraArray.addObject(questao.valueForKey("Alternativa\(letra)")!)
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PerguntasTableViewCell
        cell.texto.text = (self.arrayAlternativas[indexPath.row] as! String) as? String
        let letra = String(UnicodeScalar(countLetras))
        cell.LETRA.text = letra
        countLetras++
        
        cell.texto.font = UIFont (name: "Avenir book", size: 18)
        
        
        //        for index in 65...69{
        //            let letra = String(UnicodeScalar(index))
        //            outraArray.addObject(questao.valueForKey("Alternativa\(letra)")!)
        //
        //        }
        //        cell.textLabel?.numberOfLines = 0
        //        cell.textLabel?.lineBreakMode = .ByWordWrapping
        //        cell.textLabel?.text =  (self.arrayAlternativas[indexPath.row] as! String) as? String
        //        cell.textLabel?.textAlignment = .Center
        //
        
        
        
        
        
        
        //        cell.textLabel!.text =  self.arrayAlternativas[indexPath.row] as? String
        
        
        
        
        return cell
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    
    
    */
    
    
    func carregaQuestao(){
        
        //        self.arrayAlternativas = [1, 2, 3, 4, 5]
        
        
        while(arrayAlternativas.count < 5){
            let  rndNum = Int(arc4random_uniform(5))
            
            if(!arrayAlternativas.containsObject((self.outraArray[rndNum]))){
                arrayAlternativas.addObject((self.outraArray[rndNum]))
            }
            
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.auxData.questaoSelecionada = self.arrayAlternativas[indexPath.row] as! String
        questoesManager.addRepostaNoIndex(self.auxData.questaoSelecionada, index:self.auxData.indexQuestaoSelecionada - 1)
        self.iterateCells()
        auxData.arrayQuestoesVerficadas[auxData.indexQuestaoSelecionada]  = true
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PerguntasTableViewCell
        //        self.setSelectedCell(indexPath)
        
                cell.LETRA.textColor = UIColor.newOrangeColor()
        
        
        
        
    }
    func iterateCells(){
        for x in 0...self.arrayAlternativas.count - 1{
            var cellPath = NSIndexPath(forRow: x, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(cellPath) as! PerguntasTableViewCell
            cell.LETRA.textColor = UIColor.blackColor()
        
        }

   
    }
     /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
