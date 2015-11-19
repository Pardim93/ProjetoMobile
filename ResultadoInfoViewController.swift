//
//  ResultadoInfoViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 10/7/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ResultadoInfoViewController: UIViewController {
    
    
    var singletonQuestoes = QuestoesManager.singleton
    var strResposta = String()
    var strEnunciado = String()
    var strUserResposta = String()
    
    
    @IBOutlet weak var usrRespostaLabel: UILabel!
    @IBOutlet weak var respostaLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getInfo()
        self.customLabels()
        self.customTextView()
        
        updateSizes()
        
    }
    
    func getInfo(){
        self.usrRespostaLabel.text = strUserResposta
        self.textView.text = strEnunciado
        self.respostaLabel.text = strResposta
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func customTextView(){
        
        self.textView.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 6
        self.textView.clipsToBounds = true
        
        
    }
    
    func customLabels(){
        
        self.usrRespostaLabel.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.usrRespostaLabel.layer.borderWidth = 0.5
        self.usrRespostaLabel.layer.cornerRadius = 6
        self.usrRespostaLabel.clipsToBounds = true
        
        self.respostaLabel.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.respostaLabel.layer.borderWidth = 0.5
        self.respostaLabel.layer.cornerRadius = 6
        self.respostaLabel.clipsToBounds = true
        
        
    }
    
    
    func updateSizes(){
        
    }
    
    
    
    
    
    
}

