//
//  CustomNavigationViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController, UINavigationBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBarStyle()
        self.setButtonStyle()
        self.setBackButton()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "yes"
        
         self.interactivePopGestureRecognizer!.enabled = false;

    }
    
//    MARK: Estilo
    func setBarStyle(){
        
        self.navigationBar.barTintColor = UIColor.newLightBlueColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!]
        self.navigationBar.translucent = false
    }
    
    func setButtonStyle(){
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir Book", size: 20)!], forState: UIControlState.Normal)
    }
    
//    MARK: Botão
    func setBackButton(){
        let backButton = UIBarButtonItem(image: UIImage(named: "Back-44"), style: .Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func goBack(){
        self.popViewControllerAnimated(true)
    }
}
