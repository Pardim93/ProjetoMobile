//
//  InserirQuestoesProvaManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 04/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestoesProvaManager: NSObject {
    static let singleton = InserirQuestoesProvaManager()
    
    var adicionadas: [PFObject] = []
    
//    MARK: Compare
    func questaoExiste(questao: PFObject) -> Bool{
        for quest in adicionadas{
            if(quest.objectId == questao.objectId){
                return true
            }
        }
        
        return false
    }
    
//    MARK: Remove
    func removeQuestao(questao: PFObject) -> Int{
        for i in 0...adicionadas.count{
            let newId = adicionadas[i].objectId
            
            if(questao.objectId == newId){
                adicionadas.removeAtIndex(i)
                return i
            }
        }
        
        return 0
    }
}
