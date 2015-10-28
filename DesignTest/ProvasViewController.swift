//
//  ProvasViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ProvasViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let parseManager = ParseManager.singleton
    let activityView = CustomActivityView()
    
    var populares: NSArray?
    var recentes: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.configureSideBar()
        self.configureProvas()
        self.configSearchBar()
    }
    
//    MARK: Config
    func configureSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func configureProvas(){
        let request = parseManager.getProvas()
        populares = request.populares
        recentes = request.recentes
    }
    
    func configSearchBar(){
        self.hideBar()
    }
    
//    MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProvaCell", forIndexPath: indexPath) as! ProvasCollectionViewCell
        
        let curr = indexPath.row % 4 + 1
        
        if(segControl.selectedSegmentIndex == 0){
            cell.textLabel.text = populares?.objectAtIndex(curr-1) as? String
            cell.imageView.image = UIImage(named: "student1")
        }
        else{
            cell.textLabel.text = recentes?.objectAtIndex(curr-1) as? String
            cell.imageView.image = UIImage(named: "student2")
        }
        
        return cell
    }
  
//    MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
//    MARK: Button Action
    @IBAction func changeSection(sender: AnyObject) {
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            if(self.searchBar.alpha == 0){
                self.showBar()
            } else{
                self.hideBar()
                self.view.endEditing(true)
            }
        })
    }
    
//    MARK: View
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    MARK: SearchBar
    func hideBar(){
        self.searchBar.alpha = 0
        self.searchBar.transform.ty = -15
        self.segControl.transform.ty = -15
        self.collectionView.transform.ty = -15
        self.tableView.transform.ty = -15
    }
    
    func showBar(){
        self.searchBar.alpha = 1
        self.searchBar.transform.ty = 0
        self.segControl.transform.ty = 0
        self.collectionView.transform.ty = 0
        self.tableView.transform.ty = 0
    }
    
//    MARK: ActivityView
    func enableView(){
        self.view.userInteractionEnabled = true
        self.activityView.stopAnimating()
        self.removeActivityView()
    }
    
    func disabeView(){
        self.view.userInteractionEnabled = false
        self.insertActivityView()
        self.activityView.startAnimating()
    }
    
    func insertActivityView(){
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    func removeActivityView(){
        activityView.removeFromSuperview()
    }
}
