//
//  ErrorManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    static func getErrorForCode(errorCode: Int) -> NSError?{
        var erro: NSError?
        
        switch errorCode{
        case 1:
//            erro = ParseError.NoConnection
            break
            
        default:
            break
        }
        
        return erro!
    }
    
    static func getErrorForErrorType(type: ErrorType) -> NSError?{
        return nil
//        switch type{
//        }
    }
}

enum ParseError: ErrorType {
    case NoConnection
    case InternalError
    case UnknownError
    case UnloggedUser
}

enum LoginManagerError: ErrorType{
    
}

enum RegisterManagerError: ErrorType{
    
}