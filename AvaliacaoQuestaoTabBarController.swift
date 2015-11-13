//
//  AvaliacaoQuestaoTabBarController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 10/28/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AvaliacaoQuestaoTabBarController: UITabBarController {

    var questaoObg = PFObject(className: "Questao")
    var auxData = AuxiliarQuestoes.singleton
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViewController()
        self.configTableViewController()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configViewController(){
        let viewControlller = self.viewControllers![0] as! PerguntasAvaliacaoViewController
        viewControlller.strForTextView  = questaoObg.objectForKey("Enunciado") as! String
        self.getImageData()
        
    }
    
    func configTableViewController(){
//
        let myTableView =  self.viewControllers![1] as!  AvaliacaoQuestaoTableViewController
        let arrayAlternativas = NSMutableArray()
        
        for i in 0...4{
            let letra = String(UnicodeScalar(65 + i))
            arrayAlternativas.addObject(questaoObg.objectForKey("Alternativa\(letra)")!)
            myTableView.setArrayAlternativas(arrayAlternativas)
        }
        
    }
    
    
    func getImageData(){
        if self.auxData.questao.valueForKey("Imagem") != nil{
            let userImageFile = self.auxData.questao.valueForKey("Imagem") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let img = imageData {
                        self.auxData.imagem = UIImage(data:img)!
                        self.auxData.imgIsReady = true
                    }
                }
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
