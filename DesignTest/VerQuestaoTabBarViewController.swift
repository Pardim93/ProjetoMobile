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
    
    func loadQuestao(){
        let exeView = self.viewControllers![0] as! VerQuestaoViewController
        exeView.questao = self.questao!
        exeView.img = img
        
        let altView = self.viewControllers![1] as! VerAlternativasTableViewController
        altView.questao = self.questao!
    }
}
