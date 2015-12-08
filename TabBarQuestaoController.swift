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
        self.sendInfoToView3(self.auxQuestoes.questoes)
        self.checkQuestoes(self.auxQuestoes.questoes)
        
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
        let backBtn = UIBarButtonItem(image: UIImage(named: "Back-44"), style: .Plain, target: self, action: "getBackQuestion")
        let nextBtn = UIBarButtonItem(image: UIImage(named: "Forward-44"), style: .Plain, target: self, action: "getNextQuestion")
        
        self.navigationItem.leftBarButtonItems = [backBtn]
        self.navigationItem.rightBarButtonItems = [nextBtn]
        
        
        
        
        //        let backButton = UIBarButtonItem(image: UIImage(named: "More Filled-22"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        //                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func checkQuestoes(questoes:[PFObject]){
        
        for x in 0...questoes.count - 1{
            print(questoes[x].valueForKey("Enunciado"))
        }
    }
    
    func getBackQuestion(){
        
        
        self.navigationItem.rightBarButtonItem?.enabled = true

        if(self.auxQuestoes.indexQuestaoSelecionada > 1){
            print(self.auxQuestoes.indexQuestaoSelecionada)
            if(self.auxQuestoes.indexQuestaoSelecionada ==
                2){
                    self.navigationItem.leftBarButtonItem?.enabled = false
            }
            self.auxQuestoes.indexQuestaoSelecionada--
            self.title = "Questão \(self.auxQuestoes.indexQuestaoSelecionada )"
            
            let questao = self.auxQuestoes.questoes[self.auxQuestoes.indexQuestaoSelecionada - 1]
            self.sendInfoToView1(questao)
            self.sendInfoToView2(questao)
            let questaoTemp = questao
            self.auxQuestoes.objectId = questaoTemp.objectId!
        }
        
        
    }
    
    func getNextQuestion(){
        
        self.navigationItem.leftBarButtonItem?.enabled = true
        if(self.auxQuestoes.indexQuestaoSelecionada  < self.auxQuestoes.questoes.count ){
            if(self.auxQuestoes.indexQuestaoSelecionada == self.auxQuestoes.questoes.count - 1){
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
            self.auxQuestoes.indexQuestaoSelecionada++
            self.title = "Questão \(self.auxQuestoes.indexQuestaoSelecionada )"
            
            let questao = self.auxQuestoes.questoes[self.auxQuestoes.indexQuestaoSelecionada - 1 ]
            //        self.auxQuestoes.questao = questao
            self.sendInfoToView1(questao)
            self.sendInfoToView2(questao)
            print(questao.valueForKey("Enunciado"))
            let questaoTemp = questao
            self.auxQuestoes.objectId = questaoTemp.objectId!
        }
        
        
        
    }
    
    
    func sendInfoToView1(questao: NSObject){
        let view =  self.viewControllers?.first as! QuestaoViewController
        view.questao = questao
        
        view.callMethods()
        
        self.getImageData()
        
    }
    
    func sendInfoToView2(questao: NSObject){
        
        let view =  self.viewControllers?[1] as! AltenativasTableViewController
        
        view.outraArray.removeAllObjects()
        view.arrayAlternativas.removeAllObjects()
        view.questao = questao
        view.configView()
        view.tableView.reloadData()
        
    }
    
    func sendInfoToView3(questoes: [PFObject]){
        
        let view = self.viewControllers![2] as! QuestaoMenuTableView
        view.myArray = questoes
        
        
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
