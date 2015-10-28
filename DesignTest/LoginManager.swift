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
                //Falha ao Logar
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Email ou senha incorretos.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email ou senha digitados não são válidos.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite seus dados novamente.", comment: "")
                ]
                erro = NSError(domain: "LoginManager", code: 1, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
}