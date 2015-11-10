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
extension UIViewController{
//Mostrar ActivityView
    func configActivityView(){
        let activityView = CustomActivityView()
        activityView.tag = 30
        
        activityView.center = self.view.center
        activityView.stopAnimating()
        self.view.bringSubviewToFront(activityView)
        self.view.addSubview(activityView)
    }
    
    func enableView(){
        self.view.userInteractionEnabled = true
        
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
extension UINavigationController{
//Mostrar alertas na view
    func showAlert(mensagem: String){
        let alertController = UIAlertController(title: "Simulandos", message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK: String
extension String{
//Transformar a string para lowerCase e remover acentos
    func simpleString() -> String{
        return self.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
    
//Verificar se existem letrar na String
    func hasLetter() -> Bool{
        return self.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil
    }
    
//Verificar se existem letrar na String
    func hasAlphanumeric() -> Bool{
        return self.rangeOfCharacterFromSet(NSCharacterSet.alphanumericCharacterSet()) != nil
    }
}

//MARK: NSObject
extension NSObject{
    static func getError(errorCode: Int) -> NSError{
        return ErrorManager.getErrorForClass(NSStringFromClass(self), errorCode: errorCode)
    }
}
