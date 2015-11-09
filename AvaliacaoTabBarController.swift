//
//  AvaliacaoTabBarController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/9/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AvaliacaoTabBarController: UITabBarController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    private var auxData = AuxiliarData.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSideBar()
        
        if(auxData.flag){
            self.sendInfoToView1()
            self.sendInfoToView2()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendInfoToView1(){
    
        let view =  self.viewControllers?.first as! AvaliacaoEnunciadoViewController
        view.questao = self.auxData.questao
        self.getImageData()
    
    }
    
    func sendInfoToView2(){
        
        let view =  self.viewControllers?.last as! AvaliacaoQuestaoTableViewController
        view.questao = self.auxData.questao
        
    }
    
    func getImageData(){
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
