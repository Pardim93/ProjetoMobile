//
//  InserirQuestaoProvaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 23/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestaoProvaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomTextViewDelegate, TratarQuestaoDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchActive: Bool = false
    var filtered = NSArray()
    let parseManager = ParseManager.singleton
//    let activityView = CustomActivityView()
    let inserirQuestoesManager = InserirQuestoesProvaManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.moveViewsToAdjustSegmented()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configSearchBar()
        self.configTableView()
        
        let tabBar = self.tabBarController as! InserirProvaTabBarViewController
        tabBar.configSaveButton()
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Config
    func configSearchBar(){
        searchBar.delegate = self
    }
    
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "InserirQuestaoTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
        
        self.tableView.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
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
        self.view.endEditing(true)
        self.doSearch()
    }
    
//    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        var newText = self.searchBar.text! as NSString
//        newText = newText.stringByReplacingCharactersInRange(range, withString: text)
//        let newTextString = newText as String
//        
//        if(!newTextString.hasAlphanumeric()){
//            self.cleanBusca()
//        }
//        
//        return true
//    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.hasAlphanumeric()){
            self.cleanBusca()
        }
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
        
        guard let newQuestao = filtered.objectAtIndex(indexPath.row) as? PFObject else{
            return cell
        }
        
        cell.delegate = self
        cell.descricaoTextView.customDelegate = self
        
        cell.setInfo(newQuestao, newRow: indexPath.row)
        
        let willRemove = inserirQuestoesManager.questaoExiste(newQuestao)
        cell.setButtonStatus(!willRemove)
        
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
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        guard let newQuestao = filtered.objectAtIndex(indexPath.row) as? PFObject else{
            return
        }
        
        self.prepareGoToQuestao(newQuestao)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }

//    MARK: Delegate
    func finishEdit(cellRow: Int) {
        self.view.endEditing(true)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false)
        
        guard let newQuestao = filtered.objectAtIndex(cellRow) as? PFObject else{
            return
        }
        
        self.prepareGoToQuestao(newQuestao)
    }
    
    func tratarQuestao(questao: PFObject, willAdd: Bool) {
        if(willAdd){
            inserirQuestoesManager.adicionadas.append(questao)
        } else{
            inserirQuestoesManager.removeQuestao(questao)
        }
    }
    
//    MARK: Prepare To Change View
    func prepareGoToQuestao(questao: PFObject){
        self.disabeView()
        
        self.inserirQuestoesManager.getImg(questao){(newImg) -> () in
            self.enableView()
            self.goToQuestao(questao, img: newImg)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
//    MARK: Navigation
    func goToQuestao(questao: PFObject, img: UIImage?){
        
        let newTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("verExTabBar") as! VerQuestaoTabBarViewController
        newTabBar.questao = questao
        newTabBar.img = img
        
        self.navigationController?.pushViewController(newTabBar, animated: true)
    }
}
