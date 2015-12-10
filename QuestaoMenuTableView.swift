
//  QuestaoMenuControllerTableViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit
import QuartzCore


class QuestaoMenuTableView: UITableViewController {
    
    private var questaoSelecionada = NSObject()
    private var parseManager = ParseManager.singleton
    private var questoesManager = QuestoesManager.singleton
    var myArray: [PFObject] = []
    private var auxData = AuxiliarQuestoes.singleton
    private var firstTime = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getQuestoes()
//        self.configTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.tabBarController?.title = "Questão \(self.auxData.indexQuestaoSelecionada)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configTable()
    }
    
    //    MARK: Config
    func configTable(){
        self.configTabbarHidingCells()
        
        //        let sfondo = UIImage(named:"Table")
        //        self.view.backgroundColor = UIColor(patternImage: sfondo!)
        //
        //        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        //        let blurView = UIVisualEffectView(effect: blur)
        //        blurView.frame = self.view.bounds
        //
        //        self.tableView.headerViewForSection(0)?.backgroundColor? = UIColor.blueColor()
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 40))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
    func getQuestoes(){
        
        self.respostasQuestoes(self.myArray)
        self.auxData.questao = self.myArray[0] as AnyObject as! NSObject
        
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myArray.count + 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("questaoCell", forIndexPath: indexPath) as! QuestaoMenuTableViewCell
        
        cell.labelQuestao.font = UIFont (name: "Avenir light", size: 18)
        
        if(self.firstTime){
            
            if(indexPath.row == myArray.count ){
                self.firstTime = false
            }
         
        }
        
        if(indexPath.row == 0){
            cell.labelQuestao.text =  "Finalizar"
            cell.labelQuestao.textColor = UIColor.redColor()
        }else{
            cell.labelQuestao!.text =  "Questão \(indexPath.row)"
            cell.labelQuestao!.textColor = UIColor.blackColor()
            
            if(self.auxData.arrayQuestoesVerficadas[indexPath.row] == true){
                cell.imgMarker.image = UIImage(named: "Checkmark-100")
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self.auxData.indexAlternativa = -1
        
        if(indexPath.row == 0){
            let view = self.storyboard?.instantiateViewControllerWithIdentifier("NavResultadoViewController") as! CustomNavigationViewController
            self.auxData.questoesUsuario = questoesManager.arrayRespostas
            self.presentViewController(view, animated: true, completion: nil)
            return
            
        }else{
            
            self.tabBarController?.title = "Questão \(indexPath.row)"
            if(indexPath.row == 1){
                
                self.tabBarController?.navigationItem.leftBarButtonItem?.enabled = false
                self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = true
                
            }else if (indexPath.row == self.myArray.count){
                
                self.tabBarController?.navigationItem.leftBarButtonItem?.enabled = true
                self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = false
                
            }else{
                
                self.tabBarController?.navigationItem.leftBarButtonItem?.enabled = true
                self.tabBarController?.navigationItem.rightBarButtonItem?.enabled = true
                
            }
            
            
            
            
            self.questaoSelecionada = self.myArray[indexPath.row - 1]
            self.auxData.questao = self.questaoSelecionada
            self.auxData.flag = true
            
            let questaoTemp = self.myArray[indexPath.row - 1]
            self.auxData.objectId = questaoTemp.objectId!
            self.auxData.indexQuestaoSelecionada = indexPath.row
            
            
            self.makeTransition()
            
    
            
        }
    }
    
    func makeTransition(){
        let tabBar = self.tabBarController as! TabBarQuestaoController
        
        tabBar.sendInfoToView1(self.auxData.questao)
        tabBar.sendInfoToView2(self.auxData.questao)
        
        tabBar.resetImageView()

        
        let animation = UIViewAnimationOptions.AllowUserInteraction
        UIViewAnimationOptions.Repeat
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        tabBar.viewControllers![2].view.layer.addAnimation(transition, forKey: kCATransitionPush)
        tabBar.viewControllers![0].view.layer.addAnimation(transition, forKey: kCATransition)
        
        
        UITabBar.transitionFromView((toView:tabBar.viewControllers![2].view), toView:tabBar.viewControllers![0].view , duration: 1.9, options: animation , completion:nil)
        tabBar.selectedIndex = 0
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func respostasQuestoes(enunciados: NSArray){
        
        let arrayRepostas = NSMutableArray()
        
        for x in self.myArray{
            arrayRepostas.addObject(x)
        }
        
        self.auxData.getArrayRespostas(arrayRepostas)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
}
