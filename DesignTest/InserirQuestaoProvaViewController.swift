//
//  InserirQuestaoProvaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 23/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestaoProvaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchActive: Bool = false
    var filtered = NSArray()
    let parseManager = ParseManager.singleton
    let activityView = CustomActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moveViewsToAdjustSegmented()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configSearchBar()
        self.configTableView()
        self.configActivityView()
        
        let tabBar = self.tabBarController as! InserirProvaTabBarViewController
        tabBar.configSaveButton()
    }
    
//    MARK: Config
    func configSearchBar(){
        searchBar.delegate = self
    }
    
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "InserirQuestaoTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
    }
    
    func moveViewsToAdjustSegmented(){
        self.searchBar.transform.ty = 38
        self.tableView.transform.ty = 38
    }
    
    func configActivityView(){
        self.activityView.center = self.view.center
        self.activityView.stopAnimating()
        self.view.addSubview(activityView)
    }
    
//    MARK: SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.doSearch()
    }
    
//    MARK: Search
    func doSearch(){
        guard let text = self.searchBar.text else{
            self.tableView.reloadData()
            return
        }
        
        if((!self.lookForLetter(text)) && (!self.lookForNumber(text))){
            self.tableView.reloadData()
            return
        }
        
        self.disabeView()
        
        parseManager.getQuestoesByKeyword(text) {(parseManager, result, error) -> () in
            self.enableView()
            
            if(error != nil){
                self.navigationController?.showAlert("Ocorreu um erro")
                return
            }
            
            self.filtered = result
            
            self.tableView.reloadData()
        }
    }
    
    func lookForLetter(newPassword: NSString) -> Bool{
        let rangeOfLeters = newPassword.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet())
        
        return (rangeOfLeters.length > 0)
    }
    
    func lookForNumber(newPassword: NSString) -> Bool{
        let rangeOfNumbers = newPassword.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet())
        
        return (rangeOfNumbers.length > 0)
    }
    
//    MARK: TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! InserirQuestaoTableViewCell
        
        cell.questao = filtered.objectAtIndex(indexPath.row) as! PFObject
        cell.setDescricao()
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
//    MARK: View
    func enableView(){
        self.view.userInteractionEnabled = true
        self.activityView.stopAnimating()
    }
    
    func disabeView(){
        self.view.userInteractionEnabled = false
        self.activityView.startAnimating()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
}
