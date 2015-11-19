//
//  TabBarQuestaoController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class TabBarQuestaoController: UITabBarController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    private var auxQuestoes = AuxiliarQuestoes.singleton
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSideBar()
        
        if(auxQuestoes.flag){
            //Carrega info de uma questao somente se o usuario tenha escolhido uma questao
            
            self.sendInfoToView1()
            self.sendInfoToView2()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendInfoToView1(){
        
        let view =  self.viewControllers?.first as! QuestaoViewController
        view.questao = self.auxQuestoes.questao
        
        self.getImageData()
        
    }
    
    func sendInfoToView2(){
        
        let view =  self.viewControllers?.last as! AltenativasTableViewController
        view.questao = self.auxQuestoes.questao
        
    }
    
    
    
    func getImageData(){
        if self.auxQuestoes.questao.valueForKey("Imagem") != nil{
            let userImageFile = self.auxQuestoes.questao.valueForKey("Imagem") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let img = imageData {
                        self.auxQuestoes.imagem = UIImage(data:img)!
                        self.auxQuestoes.imgIsReady = true
                    }
                }
            }
        }
    }
    
    
    
    func configSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
