//
//  ProvasViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ProvasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let parseManager = ParseManager.singleton
    var filtered = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSideBar()
        self.configSearchBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
        self.configureProvas()
    }
    
//    MARK: Config
    func configureSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "ListaProvaTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
    }
    
    func configureProvas(){
        self.disabeView()
        
        parseManager.getProvasPopulares { (result, error) -> () in
            self.enableView()
            if(error == nil){
                if(result != nil){
                    self.filtered = result!
                    self.tableView.separatorStyle = .None
                }
                else{
                    self.filtered = NSArray()
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    self.tableView.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
                }
                
                self.tableView.reloadData()
            }
            else{
                self.navigationController?.showAlert("Erro ao buscar")
            }
        }
    }
    
    func configSearchBar(){
        self.hideBar()
        
        self.searchBar.delegate = self
    }
    
//    MARK: SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.doSearch()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.hasAlphanumeric()){
            self.cleanBusca()
        }
    }
    
    func hideBar(){
        self.searchBar.alpha = 0
        self.searchBar.transform.ty = -15
        self.segControl.transform.ty = -15
        self.tableView.transform.ty = -15
    }
    
    func showBar(){
        self.searchBar.alpha = 1
        self.searchBar.transform.ty = 0
        self.segControl.transform.ty = 0
        self.tableView.transform.ty = 0
    }
    
//    MARK: Search
    func cleanBusca(){
        self.filtered = NSArray()
        self.tableView.reloadData()
    }
    
    func doSearch(){
        guard let text = self.searchBar.text else{
            self.tableView.reloadData()
            return
        }
        
        if(!text.hasAlphanumeric()){
            self.tableView.reloadData()
            return
        }
        
        self.disabeView()
        
        parseManager.getProvasByKeyword(text) {(result, error) -> () in
            self.enableView()
            
            if(error != nil){
                self.navigationController?.showAlert("Ocorreu um erro")
                return
            }
            
            self.filtered = result!
            
            self.tableView.reloadData()
        }
    }
  
//    MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! ListaProvaTableViewCell
        
        cell.setNewProva(filtered.objectAtIndex(indexPath.row) as! PFObject)
        cell.setColor(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
//    MARK: Button Action
    @IBAction func changeSection(sender: AnyObject) {
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
}
