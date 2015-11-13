//
//  LoginManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    static let singleton = LoginManager()
    let parseManager = ParseManager.singleton
    
    func trySignIn(email: String, senha: String, completionHandler:(LoginManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            let logged = self.parseManager.doLogin(email, senha: senha)
            if(logged){
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(self, erro)
                })
            }
            else{
                erro = self.getError(LoginManagerError.IncorrectData)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
}