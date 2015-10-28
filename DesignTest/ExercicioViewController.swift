//
//  ExercicioViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ExercicioViewController: UIViewController {
    
    var questao: PFObject?
    private var timer = NSTimer()
    private let questoesManager = QuestoesManager.singleton
    private var popViewController = PopUpViewController()
    
    var flag = true
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var txtExercicio: UITextView!
    var imgExercicio = UIImageView()
    
    var atual: Int = 0
    var arrayQuestao: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.customImgView()
        self.customTextView()
        self.scrollView.sizeToFit()
        self.carregaQuestao()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "loadImage", userInfo: nil, repeats: true)
        
    }
    
    
    func createButton(){
        let button   = UIButton()
        button.setBackgroundImage(UIImage(named:"LupaZoom"), forState: .Normal )
        button.tag = 1
        button.addTarget(self, action: "buttonPopUp:", forControlEvents: .TouchDown)
        
        
        button.frame = CGRectMake(210, 210, 30, 30)
        
        self.imgExercicio.addSubview(button)
        
        
        
    }
    
    func buttonPopUp(sender:UIButton!){
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPad", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                    self.popViewController.title = "Imagem do Enunciado"
                    self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: self.titulo.text, animated: true)
                } else {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6", bundle: nil)
                    self.popViewController.title = "Imagem do Enunciado"
                    self.popViewController.showInView(self.view, withImage:imgExercicio.image, withMessage: self.titulo.text, animated: true)
                }
            } else {
                self.popViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
                self.popViewController.title = "Imagem do Enunciado"
                self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: self.titulo.text, animated: true)
            }
        }
        
    }
    
    func customImgView(){
        self.imgExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.imgExercicio.layer.borderWidth = 0.5
        self.imgExercicio.layer.cornerRadius = 6
        self.imgExercicio.clipsToBounds = true
        self.createButton()
        
        
    }
    
    func customTextView(){
        self.txtExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.txtExercicio.layer.borderWidth = 0.5
        self.txtExercicio.layer.cornerRadius = 6
        self.txtExercicio.clipsToBounds = true
        
    }
    override func viewWillAppear(animated: Bool) {
        self.title = self.getTitle()
    }
    
    func configEnunciado(){
        self.txtExercicio.text = self.questao!.objectForKey("Enunciado") as! String
        self.txtExercicio.font = UIFont(name: "Avenir Book", size: 15)
    }
    
    func getTitle() -> String{
        let newTitle = "Questão \(atual) - "
        return newTitle
    }
    
    
    
    
    @IBAction func getBackToMenu(sender: AnyObject) {
        
        //        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //        let screenWidth = screenSize.width
        //        let screenHeight = screenSize.height
        //        imgExercicio.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func loadImage(){
        print(questoesManager.imgIsReady)
        if(questoesManager.imgIsReady){
            self.imgExercicio.image = questoesManager.returnImg()
            timer.invalidate()
        }
    }
    
    func carregaQuestao(){
        print("Carregou a questao")
        questoesManager.questaoCarregada = true
        self.configEnunciado()
        self.titulo.text = self.questao!.objectForKey("Titulo") as? String
        
        
        self.imgExercicio.frame.size = CGSizeMake(250, 250)
        //
        self.imgExercicio.center = CGPointMake(self.view.center.x, 180)
        
        self.txtExercicio.transform.ty = 0
        self.txtExercicio.transform.ty = 250
        imgExercicio.userInteractionEnabled = true
        self.view.addSubview(imgExercicio)
        self.scrollView.addSubview(imgExercicio)
        
        
    }
}
