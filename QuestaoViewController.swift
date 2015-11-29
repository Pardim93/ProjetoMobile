//
//  QuestaoViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class QuestaoViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    private var popViewController = PopUpViewController()
    
    @IBOutlet weak var txtEnunciado: UITextView!
    @IBOutlet weak var imgExercicio: UIImageView!
    private var timer = NSTimer()
    private var auxData = AuxiliarQuestoes.singleton
    private var parseManager = ParseManager.singleton
    private var questoesManager = QuestoesManager.singleton
    var questao = NSObject()
    
//    func getRandomQuestao(){
//        parseManager.getProvasRecentes { (result, error) -> () in
//            if(error == nil){
//               
//                self.recentes = result
//                if(result.count > 0){
//                    self.tableView.separatorStyle = .None
//                    self.configureDisciplinas()
//                    return
//                }
//                else{
//                    self.enableView()
//                    self.configEmptyTableView()
//                    return
//                }
//            }
//            else{
//                self.enableView()
//                self.filtered = []
//                self.configEmptyTableView()
//                self.tableView.reloadData()
//                self.navigationController?.showAlert("Erro ao buscar")
//                return
//            }
//        }
//    }
    override
    func viewWillAppear(animated: Bool) {
        self.tabBarController?.title = "Questão \(self.auxData.indexQuestaoSelecionada)"
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customImg()
        self.customTextView()
        self.createButton()
        self.view.backgroundColor = UIColor.whiteColor()
        self.checkFlag()
        self.configView()

        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    func createButton(){
        imgExercicio.userInteractionEnabled = true
        
        let button   = UIButton()
        button.setBackgroundImage(UIImage(named:"LupaZoom"), forState: .Normal )
        button.tag = 1
        button.addTarget(self, action: "buttonPopUp:", forControlEvents: .TouchDown)
        
        
        button.frame = CGRectMake(220, 180, 30, 30)
        
        self.imgExercicio.addSubview(button)
        
        
        
    }
    
    
    
    func buttonPopUp(sender:UIButton!){
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPad", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
        } else {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                    self.popViewController.title = "Imagem do Enunciado"
                    self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: "Imagem", animated: true)
                } else {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6", bundle: nil)
                    self.popViewController.title = "Imagem do Enunciado"
                    self.popViewController.showInView(self.view, withImage:imgExercicio.image, withMessage: "Imagem", animated: true)
                }
            } else {
                
                self.popViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
                self.popViewController.title = "Imagem do Enunciado"
                self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: "Imagem", animated: true)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func thumbsUp(sender: AnyObject) {
        
        
    }
    
    @IBAction func thumbsDown(sender: AnyObject) {
        
        
    }
    
    
    
    func customTextView(){
        
        self.txtEnunciado.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
//        self.txtEnunciado.layer.borderWidth = 0.5
        self.txtEnunciado.layer.cornerRadius = 6
        self.txtEnunciado.clipsToBounds = true
        
        
    }
    
    func customImg(){
        
        self.imgExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
//        self.imgExercicio.layer.borderWidth = 0.5
        self.imgExercicio.layer.cornerRadius = 6
        self.imgExercicio.clipsToBounds = true
        
        self.imgExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.imgExercicio.layer.borderWidth = 0.5
        self.imgExercicio.layer.cornerRadius = 6
        self.imgExercicio.clipsToBounds = true
        
        
    }
    
    
    
    
    func checkFlag(){
        
            timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "loadImage", userInfo: nil, repeats: true)
        
        
    }
    
    func loadImage(){
        if(self.auxData.imgIsReady){
            self.imgExercicio.image = auxData.returnImg()
            self.auxData.imgIsReady = false
            timer.invalidate()
        }
    }
    
    func configView(){
        self.questao = self.auxData.questao
        self.txtEnunciado.text = self.questao.valueForKey("Enunciado") as! String
        
        
    }
    
 override   func viewDidDisappear(animated: Bool) {
        self.timer.invalidate()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToRespostas"){
            
            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
