//
//  AuxiliarData.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/9/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AuxiliarData: NSObject {

    static let  singleton = AuxiliarData()
    var questao = NSObject()
    var flag = Bool()
    var n = 0
    var imagem = UIImage()
    var imgIsReady = false
    var  objectId = String()
    
    func returnImg()->UIImage{
        return self.imagem
    }
    

}
