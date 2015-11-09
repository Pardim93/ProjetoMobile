//
//  ErrorManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 09/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    static func getErrorForClass(className: String, errorCode: Int) -> NSError{
        var erro: NSError?
        
        switch className{
        case "ParseManager":
            erro = getParseManagerError()
            break
            
        default:
            break
        }
        
        return erro!
    }
    
    static func getParseManagerError() -> NSError?{
        var erro: NSError?
        return erro
    }
}
