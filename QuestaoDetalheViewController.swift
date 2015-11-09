//
//  QuestaoDetalheViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/6/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class
QuestaoDetalheViewController: UIViewController {
    @IBOutlet weak var button: UIBarButtonItem!
    var questao = NSObject()
    var flag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSideBar()
        
        if(flag){
            
            self.txtEnunciado.text = questao.valueForKey("AlternativaA") as? String
        }
    }
    
    @IBOutlet weak var txtEnunciado: UILabel!
    func configSideBar(){
        if self.revealViewController() != nil {
            button.target = self.revealViewController()
            button.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
