//
//  MyTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/6/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
    private var parseManager = ParseManager()
    private var questoesManager = QuestoesManager()
    private var myArray = NSArray()
    private var selectedQuestion = PFObject()
    
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
        self.selectedQuestion = self.myArray.objectAtIndex(indexPath.row) as! PFObject
        //        self.popoverPresentationController
        //    self.performSegueWithIdentifier("sw_front", sender:self)
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
    
    //   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if(segue.identifier == "sw_front"){
    //
    ////            var myView = QuestaoDetalheViewController()
    ////            myView.str = self.selectedQuestion.objectForKey("Enunciado") as! String
    //            
    //        }
    //        
    //    }
    
    

}
