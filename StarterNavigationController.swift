//
//  StarterNavigationController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/17/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class StarterNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setBarStyle()
//        self.setButtonStyle()
//        setBackButton()
        
        self.navigationController!.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Volta", style: UIBarButtonItemStyle.Bordered, target: self, action: "Back:")
        self.navigationItem.leftBarButtonItem = newBackButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setBarStyle(){
        self.navigationController!.navigationBar.barTintColor = UIColor.newLightBlueColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!
            
            
            .navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!]
        self.navigationController!.navigationBar.translucent = false
    }
    
    func setButtonStyle(){
        self.navigationController!.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!], forState: UIControlState.Normal)
    }
    
    
    //    MARK: Botão
    func setBackButton(){
        let backButton = UIBarButtonItem(image: UIImage(named: "Back-44"), style: .Plain, target: self, action: "goBack")
        self.navigationController!.navigationItem.leftBarButtonItem = backButton
    }
    
    func goBack(){
        if self.revealViewController() != nil {
            self.navigationController!.navigationItem.leftBarButtonItem!.target = self.revealViewController()
            self.navigationController!.navigationItem.leftBarButtonItem!.action = "revealToggle:"
            self.navigationController!.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func Back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
//        self.navigationController?.popViewControllerAnimated(true)
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
