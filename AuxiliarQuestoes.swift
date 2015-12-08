
//
//  AuxiliarQuestoes.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AuxiliarQuestoes: NSObject {
    
    static let  singleton = AuxiliarQuestoes()
    var questao = NSObject()
    var flag = Bool()
    var imagem = UIImage()
    var imgIsReady = false
    var  objectId = String()
    var questaoSelecionada = String()
    var indexQuestaoSelecionada = Int()
    var questoesCorretas = NSArray()
    var questoesUsuario = NSArray()
    var arrayQuestoesVerficadas = [Bool](count: 900, repeatedValue: false)
    var choosenIndex = Int()
    var questoes = [PFObject]()
    

    
    func returnImg()->UIImage{
        return self.imagem
    }
    
    func limpaArrayBool(){
        var count = arrayQuestoesVerficadas.count
        count = count - 1
        for x in 0...count{
            arrayQuestoesVerficadas[x] = false
        }
    }
    
    func getArrayRespostas(arrayRespostas: NSArray){
        
        self.questoesCorretas = arrayRespostas
        
       
        
    }
    
    func getArrayRespostasUsuario(arrayRespostas: NSArray){
        
        self.questoesUsuario = arrayRespostas
        
    }
    
    func cleanVariables(){
        
        arrayQuestoesVerficadas = [Bool](count: 900, repeatedValue: false)
        imgIsReady = false
        choosenIndex = 0
        indexQuestaoSelecionada = 0
        

    }
    
    
    
    

}
