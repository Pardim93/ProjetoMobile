//
//  ErrorManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    //Descrição do erro (será mostrado ao usuário)
    static let descriptionDictionary: [String : String] = [
        //ParseManager
        "InternalError" : "Os servidores estão ocupados. Tente novamente mais tarde.",
        "InvalidObject" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "NoConnection" : "Por favor, verifique sua conexão com a internet.",
        "RegisteredEmail" : "O email já está sendo utilizado por outro usuário.",
        "UnknownError" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "UnloggedUsed" : "Ocorreu um erro. Por favor, tente novamente mais tarde",
        
        //LoginManager
        "IncorrectData" : "Email ou senha incorretos.",
        
        //RegisterManager
        "InvalidEmail" : "Email inválido.",
        "InvalidPassword" : "A senha deve ter 6 ou mais dígitos, com ao menos uma letra e um número."
    ]
    
    //Razão da falha
    static let failueReasonDictionary: [String : String] = [
        //ParseManager
        "InternalError" : "Os servidores estão ocupados. Tente novamente mais tarde.",
        "InvalidObject" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "NoConnection" : "Por favor, verifique sua conexão com a internet.",
        "RegisteredEmail" : "O email digitado já está sendo usado.",
        "UnknownError" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "UnloggedUsed" : "Ocorreu um erro. Por favor, tente novamente mais tarde",
        
        //LoginManager
        "IncorrectData" : "Email ou senha digitados não são válidos.",
        
        //RegisterManager
        "InvalidEmail" : "O email digitado não existe.",
        "InvalidPassword" : "A senha digitada não é válida."
    ]
    
    //Sugestão de recuperação
    static let recoverySuggestionDictionary: [String : String] = [
        //ParseManager
        "InternalError" : "Os servidores estão ocupados. Tente novamente mais tarde.",
        "InvalidObject" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "NoConnection" : "Por favor, verifique sua conexão com a internet.",
        "RegisteredEmail" : "Digite um novo email",
        "UnknownError" : "Ocorreu um erro. Por favor, tente novamente mais tarde.",
        "UnloggedUsed" : "Ocorreu um erro. Por favor, tente novamente mais tarde",
        
        //LoginManager
        "IncorrectData" : "Digite seus dados novamente.",
        
        //RegisterManager
        "InvalidEmail" : "Digite um novo email.",
        "InvalidPassword" : "Digite uma nova senha"
    ]
    
    //Código do erro
    static let codeDictionary: [String : Int] = [
        //ParseManager
        "InternalError" : 200,
        "InvalidObject" : 201,
        "NoConnection" : 202,
        "RegisteredEmail" : 203,
        "UnloggedUsed" : 204,
        
        //LoginManager
        "IncorrectData" : 300,
        
        //RegisterManager
        "InvalidEmail" : 400,
        "InvalidPassword" : 401,
        
        //Desconhecido
        "UnknownError" : -1
    ]
    
    static func getErrorForCode(errorCode: Int) -> NSError?{
        switch errorCode{
        case -1:
            //Erro desconhecido
            return self.getErrorForErrorType(ParseError.UnknownError)
            
        case 1:
            //Erro do parse
            return self.getErrorForErrorType(ParseError.InternalError)
            
        case 100:
            //Erro de conexão
            return self.getErrorForErrorType(ParseError.NoConnection)
            
        default:
            //Erro desconhecido
            return self.getErrorForErrorType(ParseError.UnknownError)
        }
    }
    
    static func getErrorForErrorType(type: ErrorType) -> NSError?{
        let typeString = "\(type)"
        
        let domain: String = "Vestibulandos"
        let code: Int = codeDictionary[typeString]!
        let description: String = descriptionDictionary[typeString]!
        let failureReason: String = failueReasonDictionary[typeString]!
        let recoverySuggestion: String = recoverySuggestionDictionary[typeString]!
        
        let userInfo: [NSObject : String] = [
            NSLocalizedDescriptionKey : NSLocalizedString(description, comment: ""),
            NSLocalizedFailureReasonErrorKey : NSLocalizedString(failureReason, comment: ""),
            NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(recoverySuggestion, comment: "")
        ]
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}

enum ParseError: ErrorType {
    //Erro interno
    case InternalError
    
    //Objeto inválido
    case InvalidObject
    
    //Erro de conexão
    case NoConnection
    
    //Email já utilizado
    case RegisteredEmail
    
    //Erro desconhecido
    case UnknownError
    
    //Usuário deslogado
    case UnloggedUser
}

enum LoginManagerError: ErrorType{
    //Dados incorretos
    case IncorrectData
    
    //Erro desconhecido
    case UnknownError
}

enum RegisterManagerError: ErrorType{
    //Email inválido
    case InvalidEmail
    
    //Senha inválida
    case InvalidPassword
    
    //Erro desconhecido
    case UnknownError
}