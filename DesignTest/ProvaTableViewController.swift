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
    @IBOutlet weak var numQuestoes: UILabel!
    @IBOutlet weak var disciplinas: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var prova: PFObject!
    var discs: String!
    let parseManager = ParseManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configProva()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.configStars()
        self.configActivityView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
//    MARK: Config
    func configProva(){
        self.configAutor()
        self.configNumQuestoes()
        self.configDisciplinas()
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
    
    func configAutor(){
        guard let user = prova.objectForKey("Autor") as? PFObject else{
            self.userName.text = ""
            return
        }
        let nome = user.objectForKey("Nome") as! String
        self.userName.text = nome
    }
    
    func configNumQuestoes(){
        let numberOfQuestoes = prova.objectForKey("NumQuestoes") as! Int
        self.numQuestoes.text = "\(numberOfQuestoes)"
    }
    
    func configDisciplinas(){
        self.disciplinas.text = self.discs
    }
    
//    MARK: Set
    func setNewProva(prova: PFObject, discs: String){
        self.prova = prova
        self.discs = discs
    }
    
//    MARK: TableView
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.switchSelected(indexPath.row)
    }
    
 
    func switchSelected(row: Int){
        switch(row){
        case 0:
            self.goToProfile(self)
            break
        default:
            break
        }
    }
    
//    MARK: Button
    @IBAction func willEdit(sender: AnyObject) {
        self.showActionSheet()
    }
    
    @IBAction func goToProfile(sender: AnyObject) {
        let newStoryboard = UIStoryboard(name: "IPhonePerfil", bundle: nil)
        let newView = newStoryboard.instantiateInitialViewController() as? PerfilTableViewController
        
        let user = PFUser.currentUser()
        newView?.user = user
        
        self.navigationController?.pushViewController(newView!, animated: true)
    }
    
//    MARK: Action Sheet
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Vestibulandos", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(self.createDenunciarAction())
        actionSheet.addAction(self.createCancelAction())
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createDenunciarAction() -> UIAlertAction{
        let denunciarAction = UIAlertAction(title: "Denunciar", style: .Default) { (action) in
            self.denunciarProva()
        }
        
        return denunciarAction
    }
    
    func createCancelAction() -> UIAlertAction{
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        return cancelAction
    }
    
//    MARK: Funcoes
    func denunciarProva(){
        self.disabeView()
        parseManager.criarDenunciaProva(self.prova) { (erro) -> () in
            self.enableView()
            guard let erroNotNil = erro else{
                self.navigationController?.showAlert("Prova denunciada. Agradecemos sua contribuição.")
                return
            }
            
            self.navigationController?.showAlert(erroNotNil.localizedDescription)
            return
        }
        
        return
    }
}
