//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//


import UIKit





class MenuController: UITableViewController {
    struct questao {
        
        var enunciado = String()
        var alternativaA = String()
        var alternativaB = String()
        var alternativaC = String()
        var alternativaD = String()
        var alternativaE = String()
        
    }
    
    
    private var questaoSelecionada = NSObject()
    private var parseManager = ParseManager()
    private var myArray = NSArray()
    
    
    func getQuestaoData(q:NSObject)-> MenuController.questao{
        
        let q =  questao.init(enunciado: q.valueForKey("Enunciado") as! String, alternativaA: q.valueForKey("Enunciado") as! String, alternativaB: q.valueForKey("Enunciado") as! String, alternativaC: q.valueForKey("Enunciado") as! String, alternativaD: q.valueForKey("Enunciado") as! String, alternativaE: q.valueForKey("Enunciado") as! String)

        return q
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getQuestoes()
        print(self.myArray.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.questaoSelecionada = self.myArray.objectAtIndex(indexPath.row) as! NSObject
        
        self.performSegueWithIdentifier("sw_front", sender: self)
        
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myArray.count
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text =     self.myArray.objectAtIndex(indexPath.row).objectForKey("Enunciado") as? String
        // Configure the cell...
        
        print(self.myArray.objectAtIndex(indexPath.row))
        
        return cell
    }
    
    func getQuestoes(){
        self.myArray = (parseManager.getLeastRatedQuestions())
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
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
    
            if(segue.identifier == "sw_front"){
    
                let myView = QuestaoDetalheViewController()
                myView.questao = self.questaoSelecionada
                myView.flag = true
                
            
    
            }
    
        }
    
    
    
    
}
