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
    @IBOutlet weak var switchShowEmail: UISwitch!
    
    let parseManager = ParseManager.singleton
    let coreDataManager = CoreDataManager.singleton
    var backItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCells()
        self.configSaveButton()
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configBackButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Config
    func configSaveButton(){
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveDados")
        self.navigationItem.rightBarButtonItem = buttonSave
    }
    
    func configBackButton(){
        backItem = self.navigationItem.leftBarButtonItem
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back-44"), style: .Plain, target: self, action: "tryToGoBack")
//        backButton.action = "tryToGoBack"
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func configureCells(){
        self.emailTextField.text = self.configureEmail()
        self.paisLabel.text = self.configurePais()
        self.ocupacaoLabel.text = self.configureOcupacao()
        self.switchShowEmail.on = self.configureSwitch()
        
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
    
    func configureSwitch() -> Bool{
        guard let isOn = PFUser.currentUser()?.objectForKey("showEmail") as? Bool else{
            return false
        }
        
        return isOn
    }
    
//    MARK: GoBack
    func tryToGoBack(){
        guard
            let email = self.emailTextField.text,
            let pais = self.paisLabel.text,
            let ocupacao = self.ocupacaoLabel.text else{
                self.navigationController?.popViewControllerAnimated(true)
                return
        }
        
        let showEmail = self.switchShowEmail.on
        
        let dadosChecked = self.checkDadosChanged(email, pais: pais, ocupacao: ocupacao, showEmail: showEmail)
        
        if(dadosChecked.error != nil){
            let msg = dadosChecked.error?.localizedDescription
            self.navigationController!.showAlert(msg!)
            return
        }
        
        if(dadosChecked.changed){
            self.notificateConfirmation()
            return
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    MARK: Delegate
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
        
        parseManager.retrievePassword(email) { (error) -> () in
            self.enableView()
            
            if(error != nil){
                let msg = error!.localizedDescription
                self.navigationController!.showAlert(msg)
                return
            }
            
            if(self.parseManager.doLogout()){
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
        
        let showEmail = self.switchShowEmail.on
        
        let dadosChecked = self.checkDadosChanged(email, pais: pais, ocupacao: ocupacao, showEmail: showEmail)
        
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
        
        parseManager.updateUser(email, pais: pais, ocupacao: ocupacao, showEmail: showEmail) { (error) -> () in
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
    
    func checkDadosChanged(email: String, pais: String, ocupacao: String, showEmail: Bool) -> (changed: Bool, error: NSError?){
        guard let user = PFUser.currentUser() else{
            let erro = self.getError(ParseError.UnloggedUser)
            return (false, erro)
        }
        
        guard
            let oldEmail = user.objectForKey("email") as? String,
            let oldPais = user.objectForKey("pais") as? String,
            let oldOcupacao = user.objectForKey("ocupacao") as? String,
            let oldShowEmail = user.objectForKey("showEmail") as? Bool else{
                let erro = self.getError(ParseError.UnknownError)
                return (false, erro)
        }
        
        let dadosChanged = ((oldEmail != email) || (oldPais != pais) || (oldOcupacao != ocupacao || oldShowEmail != showEmail))
        
        return (dadosChanged, nil)
    }
    
//    MARK: Alert
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo resetar sua senha? Você será deslogado até que confirme a senha nova no seu email.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.recoverPassword()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showConfirmSaveAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Salvo com sucesso.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Fechar", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func notificateConfirmation(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja salvar antes de sair?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.saveDados()
        })
        alertController.addAction(UIAlertAction(title: "Não", style: .Cancel) { (action)
            in
            self.navigationItem.leftBarButtonItem = self.backItem
            self.navigationController?.popViewControllerAnimated(true)
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }

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
