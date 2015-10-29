//
//  CustomNavigationViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBarStyle()
        self.setButtonStyle()
        self.setBackButton()
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

extension UINavigationController{
    func showAlert(mensagem: String){
        let alertController = UIAlertController(title: "Simulandos", message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String{
    func simpleString() -> String{
        return self.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
}
