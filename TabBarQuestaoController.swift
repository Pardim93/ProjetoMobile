//
//  TabBarQuestaoController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class TabBarQuestaoController: UITabBarController {
    
    private var auxQuestoes = AuxiliarQuestoes.singleton
    private var questoesManager = QuestoesManager.singleton
    var backItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Questão 1"

        
            self.sendInfoToView1(self.auxQuestoes.questao)
            self.sendInfoToView2(self.auxQuestoes.questao)

        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.createMenuButton()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: CONFIG 
    
    func createMenuButton(){
        
        backItem = self.navigationItem.leftBarButtonItem
        
        let backButton = UIBarButtonItem(image: UIImage(named: "More Filled-22"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    func sendInfoToView1(questao: NSObject){
        print("NOME DA QUESTAO \(questao.valueForKey("Enunciado"))")
        let view =  self.viewControllers?.first as! QuestaoViewController
        view.questao = questao
        
        self.getImageData()
        
    }
    
    func sendInfoToView2(questao: NSObject){
        
        let view =  self.viewControllers?.last as! AltenativasTableViewController
        view.questao = questao
        
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
    
    
    
//    func configSideBar(){
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = "revealToggle:"
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//    }
//    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
