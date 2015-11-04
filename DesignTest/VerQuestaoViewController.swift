//
//  VerQuestaoViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class VerQuestaoViewController: UIViewController, UIScrollViewDelegate {
    
    var questao: PFObject?
    var img: UIImage?
    private var popViewController = PopUpViewController()
    
    @IBOutlet weak var txtExercicio: UITextView!
    @IBOutlet weak var imgExercicio: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.configImgView()
        self.configTextView()
        self.configImgView()
        
//        self.configScrollView()
    }
    
//    MARK: Config
//    func configScrollView(){
//        self.scrollView.delegate = self
//        self.scrollView.scrollEnabled = true
//        self.scrollView.userInteractionEnabled = true
//        
////        self.scrollView.frame.size = CGSizeMake(self.view.frame.width, 3000)
////        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 3000)
//        
//        guard let _ = img  else{
//            self.scrollView.frame.size = CGSizeMake(self.view.frame.width, 5000)
//            self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 5000)
//            return
//        }
//        
//        self.scrollView.frame.size = CGSizeMake(self.view.frame.width, 5000)
//        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 5000)
//    }
//    
    func configImgView(){
        
        if (self.img == nil){
            imgExercicio.image = UIImage(named: "image6")
        }
        else{
            imgExercicio.image = self.img
        }
        
//        self.imgExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
//        self.imgExercicio.layer.borderWidth = 0.5
//        self.imgExercicio.layer.cornerRadius = 5
        self.imgExercicio.contentMode = .ScaleAspectFit
        
        self.createButton()
        
        self.imgExercicio.userInteractionEnabled = true
    }
    
    func createButton(){
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"LupaZoom"), forState: .Normal )
        button.tag = 1
        button.addTarget(self, action: "buttonPopUp:", forControlEvents: .TouchDown)
        
        button.frame = CGRectMake(140, 140, 30, 30)
        
        self.imgExercicio.addSubview(button)
    }
    
    func configTextView(){
        self.txtExercicio.text = self.questao!.objectForKey("Enunciado") as! String
        self.txtExercicio.font = UIFont(name: "Avenir Book", size: 16)
        
        self.txtExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.txtExercicio.layer.borderWidth = 0.5
        self.txtExercicio.layer.cornerRadius = 6
        self.txtExercicio.clipsToBounds = true
    }
    
//    MARK: Lupa
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
                    self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: "Vestibulandos", animated: true)
                } else {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6", bundle: nil)
                    self.popViewController.title = "Imagem do Enunciado"
                    
                    self.popViewController.showInView(self.view, withImage:imgExercicio.image, withMessage: "Vestibulandos", animated: true)
                }
            } else {
                self.popViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
                self.popViewController.title = "Imagem do Enunciado"
                self.popViewController.showInView(self.view, withImage: imgExercicio.image, withMessage: "Vestibulandos", animated: true)
            }
        }
    }
}
