//
//  ListaExerciciosViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ListaExerciciosViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ResolverQuestaoDelegate, CustomTextViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var filtered: [PFObject] = []
    let parseManager = ParseManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSideBar()
        self.configSearchBar()
        self.configTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
        self.configExerciciosPopulares()
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
        
        self.tableView.registerNib(UINib(nibName: "ListaExTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
    }
    
    func configEmptyTableView(){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }
    
    func configSearchBar(){
        self.hideBar()
        
        self.searchBar.delegate = self
    }
    
    func configExerciciosPopulares(){
        self.disabeView()
        
        parseManager.getQuestoesPopulares { (result, error) -> () in
            self.enableView()
            if(error == nil){
                self.filtered = result
                if(!(self.filtered.count > 0)){
                    self.configEmptyTableView()
                }
                
                self.tableView.reloadData()
            }
            else{
                self.navigationController?.showAlert("Erro ao buscar")
            }
        }
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
        
        parseManager.getQuestoesByKeyword(text) {(result, error) -> () in
            self.enableView()
            
            if(error != nil){
                self.navigationController?.showAlert("Ocorreu um erro")
                return
            }
            
            self.filtered = []
            
            self.tableView.reloadData()
        }
    }
    
//    MARK: TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! ListaExTableViewCell
        
        let newQuestao = filtered[indexPath.row]
        
        cell.delegate = self
        cell.descricaoTextView.customDelegate = self
        
        cell.setInfo(newQuestao, newRow: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let newQuestao = self.filtered[indexPath.row]
        
        self.prepareGoToQuestao(newQuestao)
    }
    
//    MARK: Delegate
    func resolverQuestao(questao: PFObject) {
    }
    
    func finishEdit(cellRow: Int) {
        self.view.endEditing(true)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false)
        
        let newQuestao = filtered[cellRow]
        
        self.prepareGoToQuestao(newQuestao)
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
    
//    MARK: Navigation
    func prepareGoToQuestao(questao: PFObject){
        self.disabeView()
        
        parseManager.getImgForQuestao(questao) { (newImg, error) -> () in
            self.enableView()
            
            if(error == nil){
                self.goToQuestao(questao, img: newImg)
            }
            else{
                self.navigationController?.showAlert("Ocorreu um erro, tente novamente.")
            }
        }
    }
    
    func goToQuestao(questao: PFObject, img: UIImage?){
        
        let inserirProvaStoryBoard = UIStoryboard(name: "IPhoneInserirProva", bundle: nil)
        let newTabBar = inserirProvaStoryBoard.instantiateViewControllerWithIdentifier("verExTabBar") as! VerQuestaoTabBarViewController
        newTabBar.questao = questao
        newTabBar.img = img
        
        self.navigationController?.pushViewController(newTabBar, animated: true)
    }
}
