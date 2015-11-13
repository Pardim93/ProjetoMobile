//
//  RegisterManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 11/09/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class RegisterManager: NSObject {
    
    static let singleton = RegisterManager()
    let parseManager = ParseManager.singleton
    
//    MARK: Registro
    func trySignUp(email: String, senha: String, completionHandler:(RegisterManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Verifica se o email é válido
            let isEmail = self.checkEmail(email)
            if(!isEmail){
                //Email inválido
                erro = self.getError(RegisterManagerError.InvalidEmail)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
            
            //Verifica se a senha é válida
            let isSenha = self.checkPassword(senha)
            if(!isSenha){
                //Senha inválida
                erro = self.getError(RegisterManagerError.InvalidPassword)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
            
            //Verifica se o email já foi registrado
            let validEmail = self.parseManager.checkNickname(email)
            if (!validEmail){
                //Email já registrado
                erro = self.getError(ParseError.RegisteredEmail)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
            
            //Verifica se house sucesso em se registrar
            let successSignUp = self.parseManager.registerUserTemp(email, newPassword: senha)
            if(successSignUp){
                //Registrado com sucesso
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(self, erro)
                })
            }
            else{
                //Falha ao registar
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Por favor, tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro ao se registrar.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique a conexão com a internet.", comment: "")
                ]
                erro = NSError(domain: "RegisterManager", code: 4, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
    
    func tryFinishSignUp(pais: String, ocupacao: String, completionHandler:(RegisterManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Tenta se registrar
            let success = self.parseManager.registerUserDef(pais, newOcupacao: ocupacao)
            
            if (success){
                //Registrado com sucesso
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
            else{
                //Falha ao registar
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Por favor, tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro ao se registrar.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique a conexão com a internet.", comment: "")
                ]
                erro = NSError(domain: "RegisterManager", code: 5, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
    
//    MARK: Email
    func checkEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr.lowercaseString)
    }
    
//    MARK: Password
    func checkPassword(newPassword: String) -> Bool{
        let passwordAux: NSString = newPassword
        
        return (passwordAux.length >= 6) && (self.lookForNumber(newPassword)) && (self.lookForLetter(newPassword))
    }
    
    func lookForNumber(newPassword: NSString) -> Bool{
        let rangeOfNumbers = newPassword.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet())
        
        return (rangeOfNumbers.length > 0)
    }
    
    func lookForLetter(newPassword: NSString) -> Bool{
        let rangeOfLeters = newPassword.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet())
        
         return (rangeOfLeters.length > 0)
    }
}
