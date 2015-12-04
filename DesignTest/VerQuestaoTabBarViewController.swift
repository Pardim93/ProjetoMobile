//
//  VerQuestaoTabBarViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol VisualizarConteudoDelegate{
    func deleteFromTableView(object: PFObject)
}

class VerQuestaoTabBarViewController: UITabBarController {
    
    var questao: PFObject?
    var img: UIImage?
    var visualizarConteudoDelegate: VisualizarConteudoDelegate?
    
    let parseManager = ParseManager.singleton

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadQuestao()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Load
    func loadQuestao(){
        let exeView = self.viewControllers![0] as! VerQuestaoViewController
        exeView.questao = self.questao!
        exeView.img = img
        
        let altView = self.viewControllers![1] as! VerAlternativasTableViewController
        altView.questao = self.questao!
    }
    
//    MARK: ButtonAction
    @IBAction func moreButtonAction(sender: AnyObject) {
        self.showActionSheet()
    }
    
    func denunciarQuestao(){
        self.disabeView()
        parseManager.criarDenunciaQuestao(self.questao!) { (erro) -> () in
            self.enableView()
            guard let erroNotNil = erro else{
                self.navigationController?.showAlert("Exercício denunciado. Agradecemos sua contribuição.")
                return
            }
            
            self.navigationController?.showAlert(erroNotNil.localizedDescription)
            return
        }
        
        return
    }
    
    func deletarQuestao(){
        self.disabeView()
        
        parseManager.deleteQuestao(self.questao!) { (error) -> () in
            self.enableView()
            if(error != nil){
                self.navigationController?.showAlertPopView("Ocorreu um erro. Por favor, tente novamente")
                return
            }
            
            self.navigationController?.showAlert("Questão deletada com sucesso!")
            self.visualizarConteudoDelegate?.deleteFromTableView(self.questao!)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func editQuestao(){
        self.goToEditQuestao()
    }
    
    func finishEditing(){
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
//    MARK: Check
    func userIsOwner() -> Bool{
        guard let userId = PFUser.currentUser()?.objectId else{
            return false
        }
        
        let autorQuestao = self.questao?.objectForKey("Dono") as! PFUser
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
        
        if(self.userIsOwner()){
            actionSheet.addAction(self.createDeleteAction())
            actionSheet.addAction(self.createEditAction())
        }
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createDenunciarAction() -> UIAlertAction{
        let denunciarAction = UIAlertAction(title: "Denunciar", style: .Default) { (action) in
            self.denunciarQuestao()
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
    
    func createEditAction() -> UIAlertAction{
        let editAction = UIAlertAction(title: "Editar", style: .Default) { (action) in
            self.editQuestao()
        }
        return editAction
    }
    
//    MARK: Notification
    func confirmDelete(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Tem certeza de que você quer deletar essa questão?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.deletarQuestao()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
//    MARK: Navigation
    func goToEditQuestao(){
        let newStoryBoard = UIStoryboard(name: "IPhoneInserirExercicio", bundle: nil)
        let newView = newStoryBoard.instantiateInitialViewController() as! InserirExTabBarViewController
        newView.oldQuestao = self.questao!
        
        self.navigationController?.pushViewController(newView, animated: true)
    }
}
