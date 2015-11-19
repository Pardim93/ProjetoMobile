//
//  PerfilTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class PerfilTableViewController: UITableViewController {
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var fotoDePerfil: UIButton!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pais: UILabel!
    @IBOutlet weak var ocupacao: UILabel!
    
    var user: PFUser?
    let parseManager = ParseManager.singleton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Config
    func configTableView(){
        self.tableView.separatorColor = UIColor.newBlueColor()
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        for anyCell in tableView.visibleCells{
            let cell = anyCell
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        self.configTableViewFooter()
    }
    
    func configTableViewFooter(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 1))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
    @IBAction func willEdit(sender: AnyObject) {
        self.showActionSheet()
    }
    
    func configView(){
        self.configUser()
        self.configEmail()
    }
    
    func configUser(){
        self.nome.text = self.user?.objectForKey("Nome") as? String
        self.ocupacao.text = self.user?.objectForKey("ocupacao") as? String
    }
    
    func configEmail(){
        guard let showEmail = self.user?.objectForKey("showEmail") as? Bool else{
            self.email.text = "Informação privada"
            return
        }
        
        if(!showEmail){
            self.email.text = "Informação privada"
            return
        }
        
        guard let emailString = self.user?.objectForKey("email") as? String else{
            self.email.text = "Informação privada"
            return
        }
        
        self.email.text = emailString
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
        
        if(user?.objectId == PFUser.currentUser()?.objectId){
            self.enableView()
            
            self.navigationController?.showAlert("Ação não permitida.")
            return
        }
        
        parseManager.criarDenunciaUsuario(self.user!) { (erro) -> () in
            self.enableView()
            guard let erroNotNil = erro else{
                self.navigationController?.showAlert("Usuário denunciado. Agradecemos sua contribuição.")
                return
            }
            
            self.navigationController?.showAlert(erroNotNil.localizedDescription)
            return
        }
        
        return
    }
}
