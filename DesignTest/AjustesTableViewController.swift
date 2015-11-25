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
//    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var senhaLabel: UILabel!
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var ocupacaoLabel: UILabel!
    @IBOutlet weak var editDadosImg: UIImageView!
    @IBOutlet weak var facebookSwitch: UISwitch!
    @IBOutlet weak var googleSwitch: UISwitch!
    
    let parseManager = ParseManager.singleton
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
        
        self.facebookSwitch.on = self.configFaceSwitch()
        self.googleSwitch.on = self.configGoogleSwitch()
    }
    
    func configureEmail() -> String{
        guard let emailText = PFUser.currentUser()?.email else{
            return "Não cadastrado"
        }
        
        return emailText
    }
    
    func configurePassword() -> String{
        guard let hasPassword: Bool = PFUser.currentUser()?.objectForKey("HasPassword") as? Bool else{
            return "●●●●●●●●●●"
        }
        
        if(hasPassword){
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
    
    func configGoogleSwitch() -> Bool{
        guard let hasGoogleAcc: Bool = PFUser.currentUser()?.objectForKey("GoogleLinked") as? Bool else{
            return false
        }
        
        return hasGoogleAcc
    }
    
    func configFaceSwitch() -> Bool{
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
            self.showConfirmAlert()
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
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo sair?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.doLogout()
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
