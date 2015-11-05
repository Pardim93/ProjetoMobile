//
//  TabBarControllerExercicios.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 9/23/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class TabBarControllerExercicios: UITabBarController , UITabBarControllerDelegate{
    
    let questoesManager = QuestoesManager.singleton
    var atual = 0
    var firstTime = true
    var questao: PFObject?
//    let activityView = CustomActivityView()
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        if(firstTime){
            self.loadNovaQuestao()
            self.backBtn.enabled = false
            self.nextBtn.enabled = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
    func loadNovaQuestao(){
        questoesManager.getParseQuestao()
        questoesManager.getImageData()
        
        print(questoesManager.acabou)
        if(questoesManager.acabou){
            self.performSegueWithIdentifier("goToFinal", sender: self)
            return
        }
        questao = questoesManager.questoes.objectAtIndex(atual) as? PFObject
        print(questao?.objectForKey("Enunciado") as! String)
        
        self.loadQuestao()
        
        firstTime = false
    }
    
    func loadQuestao(){
        let exeView = self.viewControllers![0] as! ExercicioViewController
        exeView.questao = self.questao!
        
        let altView = self.viewControllers![1] as! AlternativaTableViewController
        altView.questao = self.questao!
        
        
        if(!firstTime){
            exeView.carregaQuestao()
            altView.carregaQuestao()
            altView.reloadTableView()
        }else{
            dispatch_async(dispatch_get_main_queue()) {
                self.questoesManager.getPrimeirasQuestoes()
            }
        }
    }
    
    //    func reloadViews(){
    //        let exeView = self.viewControllers![0] as! ExercicioViewController
    //        exeView.questao = self.questao!
    //
    //        let altView = self.viewControllers![1] as! AlternativaTableViewController
    //        altView.questao = self.questao!
    //
    //        if(!firstTime){
    //            exeView.carregaQuestao()
    //            altView.carregaQuestao()
    //            altView.reloadTableView()
    //        }
    //    }
    //
    //    func reloadView(){
    //        let exercicioViewController = self.viewControllers?.first as! ExercicioViewController
    //        exercicioViewController.carregaQuestao(self.questao!)
    //    }
    //
    //    func reloadTable(){
    //        let tableViewController = self.viewControllers?.last as! AlternativaTableViewController
    //        let tableView = tableViewController.tableView
    //
    //        tableViewController.carregaQuestao()
    //        tableViewController.makeSelectedCellWhite()
    //        tableView.reloadData()
    //    }
    
    
    
    
    @IBAction func questaoAnterior(sender: AnyObject) {
        atual--
        questoesManager.voltaResposta()
        
        let altView = self.viewControllers![1] as! AlternativaTableViewController

        
        altView.tableView.setContentOffset(CGPointZero, animated: false)
        
        
        self.tabBarController?.selectedIndex = 0
        
        if(atual == 0){
            self.backBtn.enabled = false
        }
        questoesManager.getImageData()
        questao = (questoesManager.questoes.objectAtIndex(atual) as! PFObject)
        self.loadQuestao()
    }
    
    @IBAction func proximaQuestao(sender: AnyObject) {
        questoesManager.avancaResposta()
        atual++
        let altView = self.viewControllers![1] as! AlternativaTableViewController
        

        altView.tableView.setContentOffset(CGPointZero, animated: false)
        
        let selectedIndex = 0
        UIView.transitionFromView(        (self.viewControllers?.last?.view)!
            , toView: (self.viewControllers?.first!.view)!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, completion: {
                finished in
                if finished {
                    self.selectedIndex = selectedIndex

                }
        })
        

        
        
        if(questoesManager.questoes.count <= atual){
            self.loadNovaQuestao()
        } else{
            questao = ((questoesManager.questoes.objectAtIndex(atual)) as! PFObject)
            self.loadQuestao()
        }
        
        self.backBtn.enabled = true
    }
}

