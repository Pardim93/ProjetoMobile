//
//  QuestoesManager.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 9/25/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class QuestoesManager: NSObject {
    
    var parseManager = ParseManager.singleton
    static let  singleton = QuestoesManager()

    
    var questaoCarregada = false
    var disciplinas = NSArray()
    var cont = 0
    var contDisc = 0
    var totalQuestoes = 0
    var totalDisc = 0
    var respostasUsuario = NSMutableArray()
    var indexQuestaoSelecionada = Int()

    
    var questaoSelecionada = NSObject()
    var contRespostas = 0
    var questoes = NSMutableArray()
    var acabou = false
    var arrayRespostas = [String]()
    private var firstScene = true
    var imgIsReady = false
    var predefinido: Bool = false
    var contQuestao = 0
    var indexQuestao = Int()
    private var imagem = UIImage()
    
    //    override init() {
    //        super.init()
    //        self.calcularQuestoes()
    //    }
    
//    func adicionaResposta(resposta:NSString){
//        respostasUsuario.addObject(resposta)
//    }
    
    func avancaResposta(){
        contRespostas++
    }
    
    func voltaResposta(){
        contRespostas--
    }
    
    func questaoFoiCarregada()-> Bool{
        return self.questaoCarregada
    }
    
    func tamanhoDasQuestoes(tamanho:Int){
 
        self.arrayRespostas = [String](count:tamanho, repeatedValue: "Sem resposta")

    }
    
    
    func adicionaResposta(resposta: NSString, index:Int){
        
        print(respostasUsuario.count)
        print(index)
        if(respostasUsuario.count > index){
            respostasUsuario.removeObjectAtIndex(index)
        }
        respostasUsuario.insertObject(resposta, atIndex: index)
    }
   
    func getPrimeirasQuestoes(){
        
        var repetidas: [String] = []
        
        for _ in 1...3{
            
            
            var questoesAtual = questoes.count
            
            if(questoesAtual != 0){
                while (questoesAtual % totalDisc != 0){
                    let oldQuestao = questoes.objectAtIndex(questoesAtual - 1) as! PFObject
                    repetidas.append(oldQuestao.objectId!)
                    questoesAtual--
                }
            }
            
            let disciplina = disciplinas.objectAtIndex(cont) as! String
            contDisc++
             
            
            if(contDisc == totalDisc){
                contDisc = 0
                cont++
            }
            
            guard let questao = parseManager.getQuestaoEnemByDisciplina(disciplina, repetidas: repetidas) else{
                acabou = true
                return
            }
            
            //            print("Questoes vindas do parse \(questao.valueForKey(\"Enunciado\"))")
            
            questoes.addObject(questao)
            
            
           
        }
    }
    
    
    func addRepostaNoIndex(resposta:String, index:Int){
        print("Tamanho da array\(self.arrayRespostas)")
        self.arrayRespostas[index] = resposta
        
        
        for x in 0...self.arrayRespostas.count - 1{
            print("Index: \(x)")
            print("Resposta: \(self.arrayRespostas[x])")
        }
    }
    
    
    func getParseQuestao(){
        
        var repetidas: [String] = []
        
        var questoesAtual = questoes.count
        
        if(questoesAtual != 0){
            while (questoesAtual % totalDisc != 0){
                let oldQuestao = questoes.objectAtIndex(questoesAtual - 1) as! PFObject
                repetidas.append(oldQuestao.objectId!)
                questoesAtual--
            }
        }
        
        let disciplina = disciplinas.objectAtIndex(cont) as! String
        contDisc++
        
        if(contDisc == totalDisc){
            contDisc = 0
            cont++
        }
        
        guard let questao = parseManager.getQuestaoEnemByDisciplina(disciplina, repetidas: repetidas) else{
            acabou = true
            return
        }
       
        questoes.addObject(questao)
        
        
        
    }
    
    func isFirstTime()-> Bool{
        return firstScene
        //Checa se é a primeeira vez que a tableView/tabbar tenta carregar as questoes puxadas
    }
    

    func calcularQuestoes(){
        let numDisc = disciplinas.count
        totalDisc = totalQuestoes/numDisc
    }
    
    func getNovaQuestao(){
        var repetidas: [String] = []
        
        var questoesAtual = questoes.count
        
        if(questoesAtual != 0){
            while (questoesAtual % totalDisc != 0){
                let oldQuestao = questoes.objectAtIndex(questoesAtual - 1) as! PFObject
                repetidas.append(oldQuestao.objectId!)
                questoesAtual--
            }
        }
        
        let disciplina = disciplinas.objectAtIndex(cont) as! String
        contDisc++
        
        if(contDisc == totalDisc){
            contDisc = 0
            cont++
        }
        
        guard let questao = parseManager.getQuestaoEnemByDisciplina(disciplina, repetidas: repetidas) else{
            return
        }
        questoes.addObject(questao)
    }
    
    func returnImg()->UIImage{
        imgIsReady = false
        return self.imagem
    }
    
   
    
    func getImageData(){
        let userImageFile = questoes[contQuestao]["Imagem"] as! PFFile
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let img = imageData {
                    self.imagem = UIImage(data:img)!
                    self.imgIsReady = true
                }
            }
        }
    }
    
    
    

    func zerar(){
        self.disciplinas = NSArray()
        self.questoes = NSMutableArray()
        self.cont = 0
        self.respostasUsuario.removeAllObjects()
        self.contRespostas = 0
        self.contQuestao = 0
        self.contDisc = 0
        self.cont = 0
        self.acabou = false
        
    }
    
}

