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
    var filtered: [PFObject] = []
    var disciplinas: [String] = []

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
        self.configureProvasPopulares()
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
    
    func configEmptyTableView(){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }
    
//    MARK: ConfigProvas
    func configureProvasPopulares(){
        self.disabeView()
        
        parseManager.getProvasPopulares { (result, error) -> () in
            if(error == nil){
                self.filtered = result
                if(result.count > 0){
                    self.tableView.separatorStyle = .None
                    self.configureDisciplinas()
                    return
                }
                else{
                    self.enableView()
                    self.configEmptyTableView()
                    return
                }
            }
            else{
                self.enableView()
                self.filtered = []
                self.configEmptyTableView()
                self.tableView.reloadData()
                self.navigationController?.showAlert("Erro ao buscar")
                return
            }
        }
    }
    
    func configureProvasRecentes(){
        self.disabeView()
        
        parseManager.getProvasRecentes { (result, error) -> () in
            if(error == nil){
                self.filtered = result
                if(result.count > 0){
                    self.tableView.separatorStyle = .None
                    self.configureDisciplinas()
                    return
                }
                else{
                    self.enableView()
                    self.configEmptyTableView()
                    return
                }
            }
            else{
                self.enableView()
                self.filtered = []
                self.configEmptyTableView()
                self.tableView.reloadData()
                self.navigationController?.showAlert("Erro ao buscar")
                return
            }
        }
    }
    
    func configureDisciplinas(){
        parseManager.getDisciplinasByArrayProvas(self.filtered) { (arrayDisciplinas, error) -> () in
            self.enableView()
            if(error == nil){
                self.disciplinas = arrayDisciplinas
                self.tableView.reloadData()
                return
            }
            else{
                self.disciplinas = []
                self.filtered = []
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.configEmptyTableView()
                self.tableView.reloadData()
                self.navigationController?.showAlert("Erro ao buscar")
                return
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
        self.filtered = []
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
            
            self.filtered = result
            
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
        
        cell.setNewProva(filtered[indexPath.row], disciplinas: self.disciplinas[indexPath.row])
        cell.setColor(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    MARK: Button Action
    @IBAction func changeSection(sender: AnyObject) {
        let selected = segControl.selectedSegmentIndex
        
        if(selected == 0){
            self.configureProvasPopulares()
            return
        }
        
        if(selected == 1){
            self.configureProvasRecentes()
            return
        }
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
