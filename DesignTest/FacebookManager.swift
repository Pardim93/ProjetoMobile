//
//  FacebookManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 06/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol FacebookDelegate{
    func finishFBLogin(erro: NSError?, novoUsuario: Bool)
}

class FacebookManager: NSObject {
    static let singleton = FacebookManager()
    let parseManager = ParseManager.singleton
    
    var delegate: FacebookDelegate? = nil
    
//    MARK: Link Facebook
    func linkFBAccount(){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        
            PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken(), block: {
                //Pega o token de facebook usado atualmente e linka ele com a conta correspondente no parse. Se não houver ele cria uma nova.
                (loggedUser: PFUser?, error: NSError?) -> Void in
                
                var erro: NSError?
                
                guard let user = loggedUser else{
                    //Não foi possível fazer o login
                    let userInfo:[NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Erro ao entrar com o facebook. Por favor, tente novamente.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao entrar com o facebook.", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
                    ]
                    
                    erro = NSError(domain: "FacebookManager", code: 1, userInfo: userInfo)
                    
                    self.delegate?.finishFBLogin(erro, novoUsuario: false)
                    return
                }
                
                //Fez o login
                self.pegaDadosUsuario(user.isNew)
                return
            })
//        })
    }
    
    func pegaDadosUsuario(isNew: Bool){
        let fields = ["fields": "first_name, last_name, email"]
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: fields)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            var erro: NSError?
            
            if (error != nil){
                // Erro ao fazer a requisição
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao tentar buscar dados do usuário.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
                ]
                erro = NSError(domain: "FacebookManager", code: 2, userInfo: userInfo)
                
                self.delegate?.finishFBLogin(erro, novoUsuario: false)
                return
            }
            else{
                guard
                    let firstName = result.valueForKey("first_name") as? String,
                    let lastName = result.valueForKey("last_name") as? String else{
                        // Um dos dados não pode ser encontrado
                        let userInfo:[NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Dados do usuário não encontrado.", comment: ""),
                            NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
                        ]
                        erro = NSError(domain: "FacebookManager", code: 3, userInfo: userInfo)
                        
                        self.delegate?.finishFBLogin(erro, novoUsuario: false)
                        return
                }
                
                //Dados encontrados
                let fullName = firstName.stringByAppendingString(" \(lastName)")
                
                self.setName(fullName, isNew: isNew)
                return
            }
        })
        
        return
    }
    
    func setName(nome: String, isNew: Bool){
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        let saved = self.parseManager.setNameForUser(nome, user: PFUser.currentUser()!)
        
        var erro: NSError?
        
        if(!saved){
            let userInfo:[NSObject : AnyObject] = [
                NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Dados do usuário não encontrado.", comment: ""),
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
            ]
            erro = NSError(domain: "FacebookManager", code: 3, userInfo: userInfo)
        }
        
        self.delegate?.finishFBLogin(erro, novoUsuario: isNew)
        return
        //        })
    }
    
//    MARK: Unlink Facebook
    func unlinkFacebook(completionHandler: (NSError?) -> ()){
        var erro: NSError?
        
        guard let user = PFUser.currentUser() else{
            let userInfo:[NSObject : AnyObject] = [
                NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro.", comment: ""),
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
            ]
            erro = NSError(domain: "FacebookManager", code: 5, userInfo: userInfo)
            
            completionHandler(erro)
            return
        }
        
        PFFacebookUtils.unlinkUserInBackground(user) { (result, error) -> Void in
            var erro: NSError?
            
            if(error != nil){
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
                ]
                erro = NSError(domain: "FacebookManager", code: 4, userInfo: userInfo)
                
                completionHandler(erro)
                return
            }
            
            if(!result){
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
                ]
                erro = NSError(domain: "FacebookManager", code: 5, userInfo: userInfo)
                
                completionHandler(erro)
                return
            }
            
            completionHandler(erro)
            return
        }
    }
    
    
//    MARK: NOT USING - Login com parse
    
    //    func loginWithFacebook(completionHandler: (FacebookManager, NSError?, Bool) -> ()){
    //
    //        let permissions = ["public_profile", "email"]
    //
    //        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
    //            (loggedUser: PFUser?, error: NSError?) -> Void in
    //
    //            var erro: NSError?
    //
    //            guard let user = loggedUser else {
    //
    //                let userInfo:[NSObject : AnyObject] = [
    //                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
    //                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao entrar com o facebook.", comment: ""),
    //                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
    //                ]
    //                erro = NSError(domain: "FacebookManager", code: 1, userInfo: userInfo)
    //
    //                completionHandler(self, erro, false)
    //                return
    //            }
    //
    //            completionHandler(self, nil, user.isNew)
    //            return
    //        })
    //    }
    
    
//    MARK: NOT USING - Login com facebook e parse
    
//    func userAvailable(){
//        let fields = ["fields": "first_name, last_name, email"]
//        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: fields)
//        
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            var erro: NSError?
//            
//            if (error != nil){
//                // Erro ao fazer a requisição
//                let userInfo:[NSObject : AnyObject] = [
//                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
//                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao tentar buscar dados do usuário.", comment: ""),
//                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
//                ]
//                erro = NSError(domain: "FacebookManager", code: 2, userInfo: userInfo)
//                
//                self.delegate?.finishFBLogin(erro, novoUsuario: false)
//                return
//            }
//            else{
//                guard
//                    let firstName = result.valueForKey("first_name") as? String,
//                    let lastName = result.valueForKey("last_name") as? String,
//                    let email = result.valueForKey("email") as? String else{
//                        // Um dos dados não pode ser encontrado
//                        let userInfo:[NSObject : AnyObject] = [
//                            NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
//                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Dados do usuário não encontrado.", comment: ""),
//                            NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
//                        ]
//                        erro = NSError(domain: "FacebookManager", code: 3, userInfo: userInfo)
//                        
//                        self.delegate?.finishFBLogin(erro, novoUsuario: false)
//                        return
//                }
//                
//                
//                
//                //                let fullName = firstName.stringByAppendingString(" \(lastName)")
//            }
//        })
//        
//        return
//    }
    
//    func linkFbAccount(completionHandler: (FacebookManager, NSError?, Bool) -> ()){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//            PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken(), block: {
//                (loggedUser: PFUser?, error: NSError?) -> Void in
//                
//                var erro: NSError?
//                
//                guard let user = loggedUser else{
//                    let userInfo:[NSObject : AnyObject] = [
//                        NSLocalizedDescriptionKey : NSLocalizedString("Erro ao entrar com o facebook. Por favor, tente novamente.", comment: ""),
//                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao entrar com o facebook.", comment: ""),
//                        NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
//                    ]
//                    
//                    erro = NSError(domain: "FacebookManager", code: 1, userInfo: userInfo)
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completionHandler(self, erro, false)
//                    })
//                    return
//                }
//                
//                self.cadastraDadosUsuario() {(facebookManager, error) -> () in
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completionHandler(self, error, user.isNew)
//                    })
//                    return
//                }
//            })
//        })
//    }
//    
//    func cadastraDadosUsuario(completionHandler: (FacebookManager, NSError?) -> ()){
//        let fields = ["fields": "first_name, last_name, email"]
//        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: fields)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            var erro: NSError?
//            
//            if (error != nil){
//                // Erro ao fazer a requisição
//                let userInfo:[NSObject : AnyObject] = [
//                    NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
//                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao tentar buscar dados do usuário.", comment: ""),
//                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
//                ]
//                erro = NSError(domain: "FacebookManager", code: 2, userInfo: userInfo)
//                completionHandler(self, erro)
//                return
//            }
//            else{
//                let parseManager = ParseManager.singleton
//                
//                guard
//                    let firstName = result.valueForKey("first_name") as? String,
//                    let lastName = result.valueForKey("last_name") as? String,
//                    let email = result.valueForKey("email") as? String else{
//                        // Um dos dados não pode ser encontrado
//                        let userInfo:[NSObject : AnyObject] = [
//                            NSLocalizedDescriptionKey : NSLocalizedString("Erro. Por favor, tente novamente.", comment: ""),
//                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Dados do usuário não encontrado.", comment: ""),
//                            NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão com a internet.", comment: "")
//                        ]
//                        erro = NSError(domain: "FacebookManager", code: 3, userInfo: userInfo)
//                        completionHandler(self, erro)
//                        return
//                }
//                
//                let fullName = firstName.stringByAppendingString(" \(lastName)")
//                parseManager.registerUserFacebook(email, name: fullName)
//                completionHandler(self, erro)
//            }
//        })
//    }
}
