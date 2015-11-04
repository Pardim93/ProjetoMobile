//
//  ProvaTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 10/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ProvaTableViewController: UITableViewController, EDStarRatingProtocol {
    
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.configureTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.configStars()
    }
    
    func configureTableView(){
        self.tableView.separatorColor = UIColor.newBlueColor()
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        for anyCell in tableView.visibleCells{
            let cell = anyCell 
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func configStars(){
        let starRating = EDStarRating()
        starRating.delegate = self;
        starRating.backgroundColor = UIColor.clearColor()
        starRating.starImage = UIImage(named: "Star-20")
        starRating.starHighlightedImage = UIImage(named: "Star Filled-20")
        starRating.maxRating = 5
        starRating.horizontalMargin = 12;
        starRating.editable = false
        starRating.displayMode = UInt(EDStarRatingDisplayFull)
        starRating.rating = 2.5;
        
        self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))?.addSubview(starRating)
        
        starRating.frame = CGRectMake(175, 0, 150, 50)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
//    MARK: TableView
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.switchSelected(indexPath.row)
    }
    
 
    func switchSelected(row: Int){
//        switch(row){
//        case 2:
//            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))?.frame.size.height = 80
//            break
//        default:
//            break
//        }
    }
    
    @IBAction func willEdit(sender: AnyObject) {
        let isHidden = !(self.navigationController?.toolbar.hidden)!
        self.navigationController?.setToolbarHidden(isHidden, animated: true)
    }
    
    @IBAction func goToProfile(sender: AnyObject) {
        let newStoryboard = UIStoryboard(name: "IPhonePerfil", bundle: nil)
        let newNav = newStoryboard.instantiateInitialViewController() as? UINavigationController
        let newView = newNav?.viewControllers[0]
        self.navigationController?.pushViewController(newView!, animated: true)
    }
}
