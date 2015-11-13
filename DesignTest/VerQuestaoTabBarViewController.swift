//
//  VerQuestaoTabBarViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 30/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class VerQuestaoTabBarViewController: UITabBarController {
    
    var questao: PFObject?
    var img: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadQuestao()
    }
    
//    MARK: Load
    func loadQuestao(){
        let exeView = self.viewControllers![0] as! VerQuestaoViewController
        exeView.questao = self.questao!
        exeView.img = img
        
        let altView = self.viewControllers![1] as! VerAlternativasTableViewController
        altView.questao = self.questao!
    }
    
//    MARK: ButtonAction
    @IBAction func moreButtonAction(sender: AnyObject) {
        self.showActionSheet()
    }
    
    func denunciarQuestao(){
        
    }
    
    func finishEditing(){
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
//    MARK: Action Sheet
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Vestibulandos", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(self.createDenunciarAction())
        actionSheet.addAction(self.createCancelAction())
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createDenunciarAction() -> UIAlertAction{
        let denunciarAction = UIAlertAction(title: "Denunciar", style: .Default) { (action) in
            self.denunciarQuestao()
        }
        
        return denunciarAction
    }
    
    func createCancelAction() -> UIAlertAction{
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        return cancelAction
    }
}
