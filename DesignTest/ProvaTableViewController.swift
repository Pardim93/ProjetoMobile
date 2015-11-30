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
    @IBOutlet weak var createdAt: UILabel!
    
    var enableDelete = true
    var questoesManager = QuestoesManager.singleton
    var prova: PFObject!
    var discs: String!
    var visualizarConteudoDelegate: VisualizarConteudoDelegate?
    let parseManager = ParseManager.singleton
    var auxQuestoes = AuxiliarQuestoes.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configProva()
        self.configTitulo()
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
        self.configCreatedAt()
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
        
        self.configFooter()
    }
    
    func configFooter(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 1))
        footer.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = footer
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
    
    func configCreatedAt(){
        let creationDate = self.prova.createdAt
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = NSTimeZone.localTimeZone()
        
        self.createdAt.text = formatter.stringFromDate(creationDate!)
    }
    
    func configTitulo(){
        guard let titulo = prova.objectForKey("Titulo") as? String else{
            return
        }
        
        self.title = titulo
    }
    
//    MARK: Set
    func setNewProva(prova: PFObject, discs: String){
        self.prova = prova
        self.discs = discs
    }

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
        
        let user = self.prova.objectForKey("Autor") as! PFUser
        newView?.user = user
        
        self.navigationController?.pushViewController(newView!, animated: true)
    }
    
    @IBAction func beginProva(sender: AnyObject) {
        self.disabeView()
        
        parseManager.getQuestoesByProva(self.prova) { (questoes, erro) -> () in
            self.enableView()
            
            if(erro != nil){
                self.navigationController?.showAlert((erro?.localizedDescription)!)
                return
            }
            
            self.goToQuestoes(questoes)
            return
        }
    }
    
    func deletarProva(){
        self.disabeView()
        
        parseManager.deleteProva(self.prova!) { (error) -> () in
            self.enableView()
            if(error != nil){
                self.navigationController?.showAlert("Ocorreu um erro. Por favor, tente novamente")
                return
            }
            
            self.navigationController?.showAlert("Questão deletada com sucesso!")
            self.visualizarConteudoDelegate?.deleteFromTableView(self.prova!)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func userIsOwner() -> Bool{
        guard let userId = PFUser.currentUser()?.objectId else{
            return false
        }
        
        let autorQuestao = self.prova?.objectForKey("Autor") as! PFUser
        let autorId = autorQuestao.objectId
        
        
        if(userId == autorId){
            return true
        }
        
        return false
    }
    
//    MARK: Action Sheet
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Vestibulandos", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(self.createDenunciarAction())
        actionSheet.addAction(self.createCancelAction())
        
        if(self.userIsOwner() && self.enableDelete){
            actionSheet.addAction(self.createDeleteAction())
        }
        
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
    
    func createDeleteAction() -> UIAlertAction{
        let deleteAction = UIAlertAction(title: "Deletar", style: .Default) { (action) in
            self.confirmDelete()
        }
        return deleteAction
    }
    
//    MARK: Notification
    func confirmDelete(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Tem certeza de que você quer deletar essa questão?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.deletarProva()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
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
    
    //    MARK: Navigation
    func goToQuestoes(questoes: [PFObject]){
        let storyboard = UIStoryboard(name: "IPhoneExercicios", bundle: nil)
        let newView = storyboard.instantiateViewControllerWithIdentifier("QuestaoSWReveal") as! SWRevealViewController
        
        
        
        
        self.navigationController?.presentViewController(newView, animated: true, completion: nil)
        //        newView.frontViewController
        //        self.questaoSelecionada = self.myArray[indexPath.row - 1]
        //        self.auxData.questao = self.questaoSelecionada
        //        self.auxData.flag = true
        //        let questaoTemp = self.myArray[indexPath.row - 1]
        //        self.auxData.objectId = questaoTemp.objectId!
        //        self.auxData.indexQuestaoSelecionada = indexPath.row
        
        self.auxQuestoes.questao = questoes[0]
        let questaoTemp = questoes[0]
        self.auxQuestoes.objectId = questaoTemp.objectId!
        self.auxQuestoes.indexQuestaoSelecionada = 1
        
        self.auxQuestoes.questao = questoes[0]
//        a.questaoSelecionada = questoes[0]
        
        print(self.auxQuestoes.questao.valueForKey("Enunciado"))
        let newMenuView = newView.rearViewController as! QuestaoMenuControllerTableViewController
        
        newMenuView.myArray = questoes
        questoesManager.tamanhoDasQuestoes(questoes.count)
    }
}
