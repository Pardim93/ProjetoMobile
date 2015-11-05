//
//  UpdateTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 02/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class UpdateTableViewController: UITableViewController, TrocarUserInfoDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var ocupacaoLabel: UILabel!
    @IBOutlet weak var senhaAtualTextField: UITextField!
    @IBOutlet weak var trocarSenhaLabel: UILabel!
    
    let parseManager = ParseManager.singleton
    let coreDataManager = CoreDataManager.singleton
//    let activityView = CustomActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCells()
        self.configSaveButton()
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
    func configSaveButton(){
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveDados")
        self.navigationItem.rightBarButtonItem = buttonSave
    }
    
    func configureCells(){
        self.emailTextField.text = self.configureEmail()
        self.paisLabel.text = self.configurePais()
        self.ocupacaoLabel.text = self.configureOcupacao()
        
        self.configureSenhaObjects()
    }
    
    func configureSenhaObjects(){
        let tupleReturn = self.configureSenha()
        
        self.senhaAtualTextField.text = tupleReturn.senha
        self.trocarSenhaLabel.text = tupleReturn.labelText
    }
    
    func configureEmail() -> String{
        guard let emailText: String = PFUser.currentUser()?.email else{
            return ""
        }
        
        return emailText
    }
    
    func configurePais() -> String{
        guard let paisText: String = PFUser.currentUser()?.objectForKey("pais") as? String else{
            return "Não cadastrado."
        }
        
        return paisText
    }
    
    func configureOcupacao() -> String{
        guard let ocupacaoText: String = PFUser.currentUser()?.objectForKey("ocupacao") as? String else{
            return "Não cadastrado"
        }
        
        return ocupacaoText
    }
    
    func configureSenha() -> (senha: String, labelText: String){
        self.senhaAtualTextField.userInteractionEnabled = false
        
        guard let hasPassword: Bool = PFUser.currentUser()?.objectForKey("HasPassword") as? Bool else{
            return ("●●●●●●●●●●", "Clique aqui para resetar sua senha")
        }
        
        if(hasPassword){
            return ("●●●●●●●●●●", "Clique aqui para resetar sua senha")
        }
        
        return ("Não cadastrada", "Clique aqui para adicionar uma senha")
    }
    
//    MARK: Setter
    func setNewValue(changeKey: String, newOpcao: String) {
        switch changeKey{
        case "Pais":
            self.paisLabel.text = newOpcao
            break
            
        case "Ocupacao":
            self.ocupacaoLabel.text = newOpcao
            break
            
        default:
            break
        }
    }
    
    //    MARK: TableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let cellId = tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier else{
            return
        }
        
        switch cellId{
        case "recuperarSenha":
            self.showConfirmAlert()
            break
            
        default:
            break
        }
    }
    
//    MARK: RecoverPassword
    func recoverPassword(){
        self.disabeView()
        guard let email = emailTextField.text else{
            self.enableView()
            return
        }
        
        parseManager.retrievePassword(email) { (parseManager, error) -> () in
            self.enableView()
            
            if(error != nil){
                let msg = error!.localizedDescription
                self.navigationController!.showAlert(msg)
                return
            }
            
            if(parseManager.doLogout()){
                self.goToHome()
            }
            else{
                self.navigationController!.showAlert("Ocorreu um erro. Tente novamente.")
            }
        }
    }
    
//    MARK: Save
    func saveDados(){
        self.disabeView()
        
        if(!self.checkEmail()){
            self.enableView()
            self.navigationController!.showAlert("Email inválido")
            return
        }
        
        guard
            let email = self.emailTextField.text,
            let pais = self.paisLabel.text,
            let ocupacao = self.ocupacaoLabel.text else{
                self.navigationController!.showAlert("Ocorreu um erro, tente novamente")
                return
        }
        
        let dadosChecked = self.checkDadosChanged(email, pais: pais, ocupacao: ocupacao)
        
        if(dadosChecked.error != nil){
            self.enableView()
            let msg = dadosChecked.error?.localizedDescription
            self.navigationController!.showAlert(msg!)
            return
        }
        
        if(!dadosChecked.changed){
            self.enableView()
            self.showConfirmSaveAlert()
            return
        }
        
        parseManager.updateUser(email, pais: pais, ocupacao: ocupacao) { (parseManager, error) -> () in
            self.enableView()
            
            if(error != nil){
                let msg = error!.localizedDescription
                self.navigationController!.showAlert(msg)
                return
            }
            
            self.showConfirmSaveAlert()
            return
        }
        
        return
    }
    
//    MARK: Check
    func emailIsNull() -> Bool{
        guard let _: String = PFUser.currentUser()?.email else{
            return true
        }
        
        return false
    }
    
    func checkEmail() -> Bool{
        let email = self.emailTextField.text
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email!.lowercaseString)
    }
    
    func senhaIsNull() -> Bool{
        guard let _: Bool = PFUser.currentUser()?.objectForKey("HasPassword") as? Bool else{
            return true
        }
        
        return false
    }
    
    func checkDadosChanged(email: String, pais: String, ocupacao: String) -> (changed: Bool, error: NSError?){
        guard let user = PFUser.currentUser() else{
            let userInfo:[NSObject : AnyObject] = [
                NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Tente novamente.", comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("O usuário local não pode ser encontrado.", comment: ""),
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, relogue.", comment: "")
            ]
            let erro = NSError(domain: "UpdateTableViewController", code: 1, userInfo: userInfo)
            return (false, erro)
        }
        
        guard
            let oldEmail = user.objectForKey("email") as? String,
            let oldPais = user.objectForKey("pais") as? String,
            let oldOcupacao = user.objectForKey("ocupacao") as? String else{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Algum dado não pode ser encontrado no usuário local.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, relogue.", comment: "")
                ]
                let erro = NSError(domain: "UpdateTableViewController", code: 2, userInfo: userInfo)
                return (false, erro)
        }
        
        let dadosChanged = ((oldEmail != email) || (oldPais != pais) || (oldOcupacao != ocupacao))
        
        return (dadosChanged, nil)
    }
    
//    MARK: Alert
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "Simulandos", message: "Você deseja mesmo resetar sua senha? Você será deslogado até que confirme a senha nova no seu email.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.recoverPassword()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showConfirmSaveAlert(){
        let alertController = UIAlertController(title: "Simulandos", message: "Salvo com sucesso.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Fechar", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
//    MARK: View
//    func enableView(){
//        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
//    }
//    
//    func disabeView(){
//        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
//    }
//    
//    MARK: Navigation
    func goToHome(){
        self.enableView()
        let storyboard = UIStoryboard(name: "IPhoneLogin", bundle: NSBundle.mainBundle())
        let nextViewController: CustomNavigationViewController = storyboard.instantiateInitialViewController() as! CustomNavigationViewController
        self.navigationController!.presentViewController(nextViewController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else{
            return
        }
        
        switch (segueIdentifier){
        case "alterarPais":
            guard let nextView = segue.destinationViewController as? TrocarInfoTableViewController else{
                return
            }
            
            nextView.delegate = self
            nextView.oldOpcao = self.paisLabel.text!
            nextView.arrayInfo = coreDataManager.getPaises()
            nextView.changeKey = "Pais"
            break
            
        case "alterarOcupacao":
            guard let nextView = segue.destinationViewController as? TrocarInfoTableViewController else{
                return
            }
            
            nextView.delegate = self
            nextView.oldOpcao = self.ocupacaoLabel.text!
            nextView.arrayInfo = ["Aluno", "Professor"]
            nextView.changeKey = "Ocupacao"
            break
            
        default:
            break
        }
    }
}
