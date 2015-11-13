//
//  RecuperarSenhaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class RecuperarSenhaViewController: UIViewController {
    
    @IBOutlet weak var confimarButton: ZFRippleButton!
    @IBOutlet weak var cancelarButton: ZFRippleButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    
    let parseManager = ParseManager.singleton
//    let activityView = CustomActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureConfirmar()
        self.configureCancelar()
        self.configureTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.userInteractionEnabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Configure
    func configureTextFields(){
        let emailImg = "Gender Neutral User Filled2-100"
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let fieldImg = UIImage(named: emailImg)
        let fieldImgView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        fieldImgView.image = fieldImg
        emailTextField.leftView = fieldImgView
    }
    
    func configureConfirmar(){
        self.confimarButton.layer.borderColor = UIColor.clearColor().CGColor
        self.confimarButton.layer.borderWidth = 0.5
        self.confimarButton.layer.cornerRadius = 5
    }
    
    func configureCancelar(){
        self.cancelarButton.layer.borderColor = UIColor.clearColor().CGColor
        self.cancelarButton.layer.borderWidth = 0.5
        self.cancelarButton.layer.cornerRadius = 5
    }

//    MARK: Button
    @IBAction func tryRetrieve(sender: AnyObject) {
        guard let email = emailTextField.text else{
            self.navigationController!.showAlert("Preencha todos os campos.")
            return
        }
        
        if(!self.checkEmail()){
            self.navigationController!.showAlert("Digite um email válido.")
            return
        }
        
        self.disabeView()
        
        parseManager.retrievePassword(email) {(error) -> () in
            self.enableView()
            
            if(error != nil){
                let msg = error!.localizedDescription
                self.navigationController!.showAlert(msg)
                return
            }
            
            self.showConfirmAlert()
        }
    }
    
//    MARK: Check
    func checkEmail() -> Bool{
        let email = self.emailTextField.text
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email!.lowercaseString)
    }
    
//    MARK: View
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
//    MARK: Navigation
    @IBAction func goBack(sender: AnyObject) {
        self.goToLogin()
    }
    
    func goToLogin(){
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    func enableView(){
//        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
//    }
//    
//    func disabeView(){
//        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
//    }
    
//    MARK: Alert
    
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "Simulandos", message: "Senha resetada com sucesso! Por favor, verifique seu email.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.goToLogin()
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
}
