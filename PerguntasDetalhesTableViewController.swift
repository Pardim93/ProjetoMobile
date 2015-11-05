//
//  PerguntasDetalhesTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/5/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class PerguntasDetalhesTableViewController: UITableViewController {
    @IBOutlet weak var button: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSideBar()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    func configureSideBar(){
        if self.revealViewController() != nil {
            button.target = self.revealViewController()
            button.action = "revealToggle:"
            //            menuButton.target = self
            //            menuButton.action = "disableViewWhileMenuActive"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.postTitleLabel.text = "WatchKit Introduction: Building a Simple Guess Game"
            cell.authorLabel.text = "Simon Ng"
            cell.authorImageView.image = UIImage(named: "author")
            
        } else if indexPath.row == 1 {
            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
            cell.postTitleLabel.text = "Building a Chat App in Swift Using Multipeer Connectivity Framework"
            cell.authorLabel.text = "Gabriel Theodoropoulos"
            cell.authorImageView.image = UIImage(named: "appcoda-300")
            
        } else {
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "A Beginner’s Guide to Animated Custom Segues in iOS 8"
            cell.authorLabel.text = "Gabriel Theodoropoulos"
            cell.authorImageView.image = UIImage(named: "appcoda-300")
            
        }
        
        return cell
    }
    


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
