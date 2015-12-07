//
//  ProvasViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ProvasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomTextViewDelegate, VisualizarConteudoDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let parseManager = ParseManager.singleton
    let emptyLabel = UILabel()
    
    var filtered: [PFObject] = []
    var populares: [PFObject] = []
    var minhas: [PFObject]?
    var recentes: [PFObject] = []
    var disciplinas: [String] = []
    var disciplinasPopulares: [String] = []
    var disciplinasRecentes: [String] = []
    var disciplinasMinhas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSideBar()
        self.configSearchBar()
        self.configEmptyLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
        
        if(self.filtered.count <= 0){
            self.configureProvasPopulares()
        }
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
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
//        self.tableView.backgroundColor = UIColor.colorWithHexString("#F5F5F5", alph: 1.0)
//        self.tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(emptyLabel)
        self.emptyLabel.center = self.view.center
    }
    
    func configEmptyLabel(){
        self.emptyLabel.text = "Não há provas correspondentes."
        self.emptyLabel.textColor = UIColor.lightGrayColor()
        self.emptyLabel.font = UIFont(name: "Avenir Book", size: 18)
        self.emptyLabel.sizeToFit()
        self.emptyLabel.alpha = 1
        
        self.emptyLabel.center = self.view.center
    }
    
    func configCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "searchButton:")
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func configSearchButton(){
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButton:")
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    //    MARK: ConfigProvas
    func configureProvasPopulares(){
        if(self.populares.count > 0){
            self.emptyLabel.removeFromSuperview()
            self.filtered = self.populares
            self.disciplinas = self.disciplinasPopulares
            self.tableView.reloadData()
            return
        }
        
        self.disabeView()
        parseManager.getProvasPopulares { (result, error) -> () in
            if(error == nil){
                self.filtered = result
                self.populares = result
                if(result.count > 0){
                    self.tableView.separatorStyle = .None
                    self.emptyLabel.removeFromSuperview()
                    self.configureDisciplinas("pop")
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
        if(self.recentes.count > 0){
            self.filtered = self.recentes
            self.disciplinas = self.disciplinasRecentes
            self.tableView.reloadData()
            return
        }
        
        self.disabeView()
        
        parseManager.getProvasRecentes { (result, error) -> () in
            if(error == nil){
                self.filtered = result
                self.recentes = result
                if(result.count > 0){
                    self.tableView.separatorStyle = .None
                    self.emptyLabel.removeFromSuperview()
                    self.configureDisciplinas("rec")
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
    
    func configMinhasProvas(){
        guard let _ = self.minhas else{
            self.disabeView()
            
            guard let autor = PFUser.currentUser() else{
                return
            }
            
            parseManager.getProvasByAutor(autor, completionHandler: { (result, error) -> () in
                if(error == nil){
                    self.filtered = result
                    self.minhas = result
                    if(result.count > 0){
                        self.tableView.separatorStyle = .None
                        self.emptyLabel.removeFromSuperview()
                        self.configureDisciplinas("min")
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
            })
            
            return
        }
        
        self.filtered = self.minhas!
        self.disciplinas = self.disciplinasMinhas
        self.tableView.reloadData()
        return
    }
    
    func configureDisciplinas(arrayToFill: String){
        parseManager.getDisciplinasByArrayProvas(self.filtered) { (arrayDisciplinas, error) -> () in
            self.enableView()
            
            self.setNewArray(arrayToFill, arrayDisciplinas: arrayDisciplinas)
            self.disciplinas = arrayDisciplinas
            
            if(error == nil){
                self.tableView.reloadData()
                return
            }
            else{
//                self.disciplinas = []
                self.filtered = []
//                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.configEmptyTableView()
                self.tableView.reloadData()
                self.navigationController?.showAlert("Erro ao buscar")
                return
            }
        }
    }
    
    func setNewArray(arrayToFill: String, arrayDisciplinas: [String]){
        switch arrayToFill{
        case "pop":
            self.disciplinasPopulares = arrayDisciplinas
            return
        case "rec":
            self.disciplinasRecentes = arrayDisciplinas
            return
        case "min":
            self.disciplinasMinhas = arrayDisciplinas
            return
        default:
            return
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
    }
    
    func showBar(){
        self.searchBar.alpha = 1
        self.searchBar.transform.ty = 0
        self.segControl.transform.ty = 0
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
            
            if(result.count <= 0){
                self.configEmptyTableView()
            }
            else{
                self.emptyLabel.removeFromSuperview()
            }
            
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
        
        cell.disciplinasTextView.customDelegate = self
        cell.disciplinasTextView.cellRow = indexPath.row
        cell.setNewProva(filtered[indexPath.row], disciplinas: self.disciplinas[indexPath.row])
        cell.setColor(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let prova = filtered[indexPath.row]
        let discs = disciplinas[indexPath.row]
        
        self.goToProva(prova, discs: discs)
    }
    
    //    MARK: Delegate
    func finishEdit(cellRow: Int) {
        self.view.endEditing(true)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false)
        
        let newProva = filtered[cellRow]
        let discs = disciplinas[cellRow]
        
        self.goToProva(newProva, discs: discs)
    }
    
    //    MARK: Button Action
    func deleteFromTableView(object: PFObject) {
        //Remove do array filtered
        
        if(self.filtered.count > 0){
        
            for index in 0...self.filtered.count-1{
                guard let _ = self.filtered[index].objectId else{
                    break
                }
                
                if(self.filtered[index].objectId == object.objectId){
                    filtered.removeAtIndex(index)
                    break
                }
            }
        }
        
        //Remove do array de populares
        
        if(self.populares.count > 0){
            for index in 0...self.populares.count-1{
                if(self.populares[index].objectId == object.objectId){
                    populares.removeAtIndex(index)
                    break
                }
            }
        }
        
        //Remove do array de recentes
        
        if(self.recentes.count > 0){
            for index in 0...self.recentes.count-1{
                if(self.recentes[index].objectId == object.objectId){
                    recentes.removeAtIndex(index)
                    break
                }
            }
        }
        
        //Remove do array de provas do usuário
        guard let _ = minhas else{
            self.tableView.reloadData()
            return
        }
        
        
        if(self.minhas!.count > 0){
            for index in 0...self.minhas!.count-1{
                
                guard let _ = self.minhas![index].objectId else{
                    break
                }
                
                if(self.minhas![index].objectId == object.objectId){
                    minhas!.removeAtIndex(index)
                    break
                }
            }
        }
        
        self.tableView.reloadData()
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
        
        if(selected == 2){
            self.configMinhasProvas()
            return
        }
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        if(self.searchBar.alpha == 0){
            UIView.animateWithDuration(0.2, animations: {
                self.showBar()
            })
            self.configCancelButton()
        } else{
            UIView.animateWithDuration(0.2, animations: {
                self.hideBar()
            })
            self.configSearchButton()
        }
    }
    
    //    MARK: View
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //    MARK: Navigation
    func goToProva(prova: PFObject, discs: String){
        let newStoryboard = UIStoryboard(name: "IPhoneProva", bundle: nil)
        let newView = newStoryboard.instantiateInitialViewController() as! ProvaTableViewController
        newView.visualizarConteudoDelegate = self
        
        newView.setNewProva(prova, discs: discs)
        
        self.navigationController?.pushViewController(newView, animated: true)
    }
}
