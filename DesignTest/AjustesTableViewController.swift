//
//  AjustesTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 24/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit
import MessageUI

class AjustesTableViewController: UITableViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var senhaLabel: UILabel!
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var ocupacaoLabel: UILabel!
    @IBOutlet weak var editDadosImg: UIImageView!
    @IBOutlet weak var facebookButton: ZFRippleButton!
    @IBOutlet weak var googleButton: ZFRippleButton!
    
    let parseManager = ParseManager.singleton
    let facebookManager = FacebookManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSideBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configureTableView()
        self.configureCells()
        self.configGestureRecognizer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Configure
    func configureTableView(){
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        for anyCell in tableView.visibleCells{
            let cell = anyCell 
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }
    
    func configureCells(){
        self.emailLabel.text = self.configureEmail()
        self.senhaLabel.text = self.configurePassword()
        self.paisLabel.text = self.configurePais()
        self.ocupacaoLabel.text = self.configureOcupacao()
        
        self.configFacebookButton()
        self.configGoogleButton()
    }
    
    func configureEmail() -> String{
        guard let emailText = PFUser.currentUser()?.email else{
            return "Não cadastrado"
        }
        
        return emailText
    }
    
    func configurePassword() -> String{
        if(self.userHasPassword()){
            return "●●●●●●●●●●"
        }
        
        return "Não cadastrada"
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
    
    func configFacebookButton(){
        self.facebookButton.layer.cornerRadius = 5
        
        if(self.facebookLogged()){
            self.facebookButton.backgroundColor = UIColor.colorWithHexString("C51419", alph: 1.0)
            self.facebookButton.rippleBackgroundColor = UIColor.colorWithHexString("C51419", alph: 0.5)
            self.facebookButton.rippleColor = UIColor.colorWithHexString("791619", alph: 1.0)
            self.facebookButton.setTitle("Logoff", forState: .Normal)
        }
    }
    
    func configGoogleButton(){
        self.googleButton.layer.cornerRadius = 5
        
        if(self.googleLogged()){
            self.googleButton.backgroundColor = UIColor.colorWithHexString("C51419", alph: 1.0)
            self.googleButton.rippleBackgroundColor = UIColor.colorWithHexString("C51419", alph: 0.5)
            self.googleButton.rippleBackgroundColor = UIColor.colorWithHexString("791619", alph: 1.0)
            self.googleButton.setTitle("Logoff", forState: .Normal)
        }
    }
    
    func configGestureRecognizer(){
        self.editDadosImg.layer
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapHandle")
        gesture.delegate = self
        self.editDadosImg.userInteractionEnabled = true
        self.editDadosImg.addGestureRecognizer(gesture)
    }
    
    func configureSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func googleLogged() -> Bool{
        guard let hasGoogleAcc: Bool = PFUser.currentUser()?.objectForKey("GoogleLinked") as? Bool else{
            return false
        }
        
        return hasGoogleAcc
    }
    
    func facebookLogged() -> Bool{
        guard let hasFacebookAcc: Bool = PFUser.currentUser()?.objectForKey("FacebookLinked") as? Bool else{
            return false
        }
        
        return hasFacebookAcc
    }

// MARK: Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        guard let identifier = cell?.reuseIdentifier else{
            return
        }
        
        switchCell(identifier)
    }
    
// MARK: Selection
    func switchCell(identifier: String){
        switch identifier{
        case "sairCell":
            self.showConfirmLogoffAlert()
            break
            
        case "feedbackCell":
            self.showEmailView()
            break
            
        default:
            break
        }
    }
    
    func tapHandle(){
        self.performSegueWithIdentifier("goToAjustes", sender: self)
    }
    
//    MARK: Check
    func userHasEmail() -> Bool{
        guard let _ = PFUser.currentUser()?.email else{
            return false
        }
        
        return true
    }
    
    func userHasPassword() -> Bool{
        guard let hasPassword: Bool = PFUser.currentUser()?.objectForKey("HasPassword") as? Bool else{
            return false
        }
        
        return hasPassword
    }
    
//    MARK: Social
    @IBAction func facebookAction(sender: AnyObject) {
        if(self.facebookLogged()){
            //Unlink Facebook
            self.showConfirmLogoffFacebookAlert()
            return
        }
        else{
            //Link Facebook
        }
    }
    
    @IBAction func googleAction(sender: AnyObject) {
        if(self.googleLogged()){
            self.showConfirmLogoffGoogleAlert()
            return
        } else{
            
        }
    }
    
    func removeFacebook(){
//        if(self.userHasEmail() && self.userHasPassword()){
//            //Usuário possui email e senha cadastrados
//            self.disabeView()
//            self.facebookManager.unlinkFacebook({ (error) -> () in
//                self.enableView()
//                
//                if(error != nil){
//                    //Ocorreu um erro
//                    self.navigationController?.showAlert(error!.localizedDescription)
//                    return
//                }
//                
//                //Unlink com sucesso
//                self.navigationController?.showAlert("Conta desvinculada com sucesso.")
//                return
//            })
//        }
//        else{
//            //Usuário não possui email e senha cadastrados
//            self.navigationController?.showAlert("Não é possível desvincular a conta. Por favor, cadastre um email e uma senha.")
//        }
    }
    
    func removeGoogle(){
        
    }
    
//    MARK: Email
    func showEmailView(){
        if(!MFMailComposeViewController.canSendMail()){
            self.navigationController?.showAlert("Você não pode mandar emails.")
            return
        }
        
        let mailView = self.createMail()
        self.navigationController?.presentViewController(mailView, animated: true, completion: nil)
    }
    
    func createMail() -> MFMailComposeViewController{
        let mailView = MFMailComposeViewController()
        mailView.mailComposeDelegate = self
        mailView.setToRecipients(["suporteVestibulandos@gmail.com"])
        
        return mailView
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            
            if(error != nil){
                self.navigationController?.showAlert("Ocorreu um erro. Tente novamente mais tarde.")
                return
            }
            
            switch result{
            case MFMailComposeResultSent:
                self.navigationController?.showAlert("Feedback enviado com sucesso!")
                break
                
            case MFMailComposeResultSaved:
                self.navigationController?.showAlert("Feedback salvo. Lembre-se de enviá-lo mais tarde.")
                break
                
            case MFMailComposeResultFailed:
                self.navigationController?.showAlert("Ocorreu um erro. Tente novamente mais tarde.")
                break
                
            case MFMailComposeResultCancelled:
                break
                
            default:
                self.navigationController?.showAlert("Ocorreu um erro. Tente novamente mais tarde.")
                break
            }
        }
    }
    
//MARK: Alert
    func showConfirmLogoffAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo sair?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.doLogout()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showConfirmLogoffFacebookAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo desvincular seu Facebook?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.removeFacebook()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showConfirmLogoffGoogleAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo desvincular sua conta google?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.removeGoogle()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
// MARK: Navigation
    func doLogout(){
        self.disabeView()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        var unlogged = false
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            unlogged = self.parseManager.doLogout()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.enableView()
                if(unlogged){
                    self.goToHome()
                }
            }
        }
    }
    
    func goToHome(){
        self.enableView()
        let storyboard = UIStoryboard(name: "IPhoneLogin", bundle: NSBundle.mainBundle())
        let nextViewController: CustomNavigationViewController = storyboard.instantiateInitialViewController() as! CustomNavigationViewController
        self.navigationController!.presentViewController(nextViewController, animated: true, completion: nil)
    }
}
