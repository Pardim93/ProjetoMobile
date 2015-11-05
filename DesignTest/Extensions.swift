//
//  Extensions.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 04/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit
import ObjectiveC

class Extensions: NSObject {

}

//MARK: UIViewController
//Mostrar ActivityView
extension UIViewController{    
    func configActivityView(){
        let activityView = CustomActivityView()
        activityView.tag = 30
        
        activityView.center = self.view.center
        activityView.stopAnimating()
        self.view.bringSubviewToFront(activityView)
        self.view.addSubview(activityView)
    }
    
    func enableView(){
        self.view.userInteractionEnabled = false
        
        let activityView = self.view.viewWithTag(30) as! CustomActivityView
        activityView.stopAnimating()
    }
    
    func disabeView(){
        self.view.userInteractionEnabled = false
        
        let activityView = self.view.viewWithTag(30) as! CustomActivityView
        activityView.startAnimating()
    }
}

//MARK: UINavigationController
//Mostrar alertas na view
extension UINavigationController{
    func showAlert(mensagem: String){
        let alertController = UIAlertController(title: "Simulandos", message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK: String
//Transformar a string para lowerCase e remover acentos
extension String{
    func simpleString() -> String{
        return self.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
}