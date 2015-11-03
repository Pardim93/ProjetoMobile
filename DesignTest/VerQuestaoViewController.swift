//
//  VerQuestaoViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class VerQuestaoViewController: UIViewController {
    
    var questao: PFObject?
    var img: UIImage?
    var imgExercicio = UIImageView()
    private var popViewController = PopUpViewController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var txtExercicio: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.customImgView()
        self.customTextView()
        self.carregaQuestao()
        
        self.configScrollView()
    }
    
//    MARK: Config
    func configScrollView(){
        self.scrollView.scrollEnabled = true
        self.scrollView.userInteractionEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 1000)
    }
    
    func customImgView(){
        
        guard let newImage = img else{
            self.imgExercicio.removeFromSuperview()
            return
        }
        
        imgExercicio.image = newImage
        self.imgExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.imgExercicio.layer.borderWidth = 0.5
        self.imgExercicio.layer.cornerRadius = 6
        self.imgExercicio.clipsToBounds = true
        self.createButton()
    }
    
    func createButton(){
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"LupaZoom"), forState: .Normal )
        button.tag = 1
        button.addTarget(self, action: "buttonPopUp:", forControlEvents: .TouchDown)
        
        button.frame = CGRectMake(210, 210, 30, 30)
        
        self.imgExercicio.addSubview(button)
    }
    
    func customTextView(){
        self.txtExercicio.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.txtExercicio.layer.borderWidth = 0.5
        self.txtExercicio.layer.cornerRadius = 6
        self.txtExercicio.clipsToBounds = true
    }
    
    func carregaQuestao(){
        self.configEnunciado()
        self.titulo.text = self.questao!.objectForKey("Titulo") as? String
        
        self.imgExercicio.frame.size = CGSizeMake(250, 250)
        self.imgExercicio.center = CGPointMake(self.view.center.x, 180)
        self.imgExercicio.userInteractionEnabled = true
        
        self.txtExercicio.transform.ty = 0
        self.txtExercicio.transform.ty = 250

//        self.view.addSubview(imgExercicio)
        self.scrollView.addSubview(imgExercicio)
    }
    
    func configEnunciado(){
        self.txtExercicio.text = self.questao!.objectForKey("Enunciado") as! String
        self.txtExercicio.font = UIFont(name: "Avenir Book", size: 15)
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
}