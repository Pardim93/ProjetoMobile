//
//  HomeViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 19/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, FacebookDelegate{
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var senhaText: UITextField!
//    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var logarButton: ZFRippleButton!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var entrarFacebook: FBSDKLoginButton!
    
    let parseManager = ParseManager.singleton
    let loginManager = LoginManager.singleton
    let registerManager = RegisterManager.singleton
    let facebookManager = FacebookManager.singleton
    var deviceName: String!
    var shouldAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deviceName = self.getDeviceName()
        
        self.configureTextFields()
        self.configureButton()
        self.configureFacebookButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startObservingKeyboardEvents()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(shouldAnimate){
            self.startView()
        }
        
        self.configActivityView()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
// MARK: Config
    func configureTextFields(){
        let emailImg = "Gender Neutral User Filled2-100"
        let senhaImg = "Key-100"
        
        configureTextField(emailText, placeholder: "Email", imgName: emailImg)
        configureTextField(senhaText, placeholder: "Senha", imgName: senhaImg)
    }
    
    func configureTextField(field: UITextField, placeholder: String, imgName: String){
        field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let fieldImg = UIImage(named: imgName)
        let fieldImgView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        fieldImgView.image = fieldImg
        field.leftView = fieldImgView
        
        field.alpha = 0
    }
    
    func configureButton(){
        self.registrarButton.alpha = 0
        self.logarButton.alpha = 0
        
        self.logarButton.layer.borderColor = UIColor.clearColor().CGColor
        self.logarButton.layer.borderWidth = 0.5
        self.logarButton.layer.cornerRadius = 5
    }
    
    func configureFacebookButton(){
        self.facebookManager.delegate = self
        self.entrarFacebook.delegate = self
        self.entrarFacebook.readPermissions = ["public_profile", "email"]
        
        self.entrarFacebook.alpha = 0
        self.entrarFacebook.layer.borderColor = UIColor.clearColor().CGColor
        self.entrarFacebook.layer.borderWidth = 0.5
        self.entrarFacebook.layer.cornerRadius = 5
    }
    
    func getDeviceName() -> String{
        let deviceType: DeviceTypes = UIDevice().deviceType
        let deviceName: String = deviceType.rawValue
        
        return deviceName
    }

//    MARK: Keyboard
    private func startObservingKeyboardEvents() {
            NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object:nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object:nil)
    }
    
    private func stopObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                
                if(self.deviceName != "iPhone 4" && self.deviceName != "iPhone 4S"){
//                    self.senhaText.transform.ty = -keyboardSize.height + 180
//                    self.emailText.transform.ty = -keyboardSize.height + 180
//                    self.logarButton.transform.ty = -keyboardSize.height + 180
                }
                else{
                    self.senhaText.transform.ty = -keyboardSize.height + 170
                    self.emailText.transform.ty = -keyboardSize.height + 170
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.senhaText.transform.ty = 0
        self.emailText.transform.ty = 0
        self.logarButton.transform.ty = 0
    }
    
//MARK: Button Func
    @IBAction func doLogin(sender: AnyObject) {
        if (!self.emailText.text!.isEmpty) && (!self.senhaText.text!.isEmpty){
            self.disabeView()
            let email = self.emailText.text
            let senha = self.senhaText.text
            
            loginManager.trySignIn(email!, senha: senha!) {(registerManager, error) -> () in
                self.enableView()
                if error != nil{
                    let msg = error!.localizedDescription
                    self.navigationController?.showAlert(msg)
                    return
                }
                self.goToMain()
            }
        }
        else{
            self.navigationController!.showAlert("Preencha todos os campos.")
        }
    }
    
    @IBAction func trySignUp(sender: AnyObject) {
        if (!self.emailText.text!.isEmpty) && (!self.senhaText.text!.isEmpty){
            self.disabeView()
            let email = self.emailText.text
            let senha = self.senhaText.text
            
            registerManager.trySignUp(email!, senha: senha!) {(registerManager, error) -> () in
                self.enableView()
                
                if error != nil{
                    let msg = error!.localizedDescription
                    self.navigationController!.showAlert(msg)
                }
                self.goToSignUp()
            }
        }
        else{
            self.navigationController!.showAlert("Preencha todos os campos")
        }
    }
    
    
    @IBAction func retrievePassword(sender: AnyObject) {
    }
    
//    MARK: Facebook
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.disabeView()
        
        if (error != nil){
            //Erro ao logar
            self.enableView()
            let msg = error!.localizedDescription
            self.navigationController!.showAlert(msg)
            return
        }
        
        if (result.isCancelled){
            //Cancelou o login
            self.enableView()
            self.navigationController!.showAlert("Login cancelado")
            return
        }
        
        if(result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile")){
            //Tudo certo, continuar com o login
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.facebookManager.linkFBAccount()
            })
            return
//            facebookManager.linkFbAccount() {(facebookManager, error, novoUsuario) -> () in
//                if(error != nil){
//                    self.enableView()
//                    //Erro ao linkar a conta
//                    let msg = error!.localizedDescription
//                    self.showAlert(msg)
//                    return
//                }
//                
//                self.continueFacebookLogin(novoUsuario)
//            }
        }
        else{
            //Permissões faltando
            self.enableView()
            self.navigationController!.showAlert("Permissões faltando, impossível continuar com o login")
            
            FBSDKLoginManager().logOut()
            PFUser.logOut()
            
            return
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.navigationController!.showAlert("Logout bem sucedido")
    }
    
    func finishFBLogin(erro: NSError?, novoUsuario: Bool) {
        if(erro != nil){
            self.enableView()
            //Erro ao linkar a conta
            let msg = erro!.localizedDescription
            self.navigationController!.showAlert(msg)
            return
        }
        
        self.continueFacebookLogin(novoUsuario)
    }
    
//    MARK: ViewStatus
//    func enableView(){
//        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
//    }
//    
//    func disableView(){
//        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
//    }
    
//MARK: Animation
    func startView(){
        let newTy = self.getTyValue(self.deviceName)
        
        UIView.animateWithDuration(1.0, animations: {
            self.title1.transform.ty = newTy
            self.title2.transform.ty = newTy
            self.emailText.alpha = 1
            self.senhaText.alpha = 1
            self.logarButton.alpha = 1
            self.registrarButton.alpha = 1
            self.entrarFacebook.alpha = 1
        })
    }
    
//Mark: Other
    func getTyValue(model: String) -> CGFloat{
        var newTy: CGFloat = 0
        switch model{
        case "iPhone 6":
            newTy = 50
            break
        case "iPhone 6S":
            newTy = 70
            break
        case "iPhone 5":
            newTy = 20
            break
        case "iPhone 5S":
            newTy = 20
            break
        case "iPhone 4":
            newTy = 0
            break
        case "iPhone 4S":
            newTy = 0
            break
        default:
            break
        }
        return newTy
    }
    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.stopObservingKeyboardEvents()
        
        if(segue.identifier == "goToRetrieve"){
            self.shouldAnimate = false
        }
    }
    
    func goToMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController: SWRevealViewController = storyboard.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewController
        self.navigationController?.presentViewController(nextViewController, animated: true, completion: nil)
    }
    
    func goToSignUp(){
        let storyboard = UIStoryboard(name: "IPhoneLogin", bundle: NSBundle.mainBundle())
        let nextViewController: RegistroViewController = storyboard.instantiateViewControllerWithIdentifier("RegistroViewController") as! RegistroViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func continueFacebookLogin(novoUser: Bool){
        if(novoUser){
            self.goToSignUp()
        } else{
            self.navigationController?.navigationBarHidden = false
            self.goToMain()
        }
    }
}
