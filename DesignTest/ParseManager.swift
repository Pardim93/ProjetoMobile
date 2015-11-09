//
//  ParseManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 27/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit



class ParseManager: NSObject {
    
    static let singleton = ParseManager()
    
//    MARK: DISCIPLINA GET
    func getDisciplinas(completionHandler:([PFObject], NSError?)->()){
        let query = PFQuery(className: "Disciplina")
        query.addAscendingOrder("Area")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            guard let result = query.findObjects() else{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro na rede. Verifique sua conexão.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro ao buscar disciplina.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Verifique sua conexão e tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 7, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
            
            var disciplinas: [PFObject] = []
            
            for item in result{
                guard let disciplina = item as? PFObject else{
                    return
                }
                
                disciplinas.append(disciplina)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(disciplinas, erro)
            })
            return
        })
    }
    
//    MARK: Login/Logout
    func autoLogin() -> Bool{
        return (PFUser.currentUser() != nil)
    }
    
    func doLogin (email: String, senha: String) -> Bool{
        PFUser.logInWithUsername(email.lowercaseString, password: senha)
        guard let _ = PFUser.currentUser() else{
            return false
        }
        
        return true
    }
    
    func doLogout() -> Bool{
        PFUser.logOut()
        
        guard let _ = PFUser.currentUser() else{
            return true
        }
        
        return false
    }
    
//  MARK: Password Recover
    func retrievePassword(email: String, completionHandler:(ParseManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            let resetted = PFUser.requestPasswordResetForEmail(email)
            
            if(resetted){
                //Senha recuperada com sucesso
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(self, erro)
                })
            }
            else{
                //Falha ao recuperar senha
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Verifique se seu email está funcionando e sua conexão funcionando.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email não utilizado ou conexão não funcionando.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email e/ou tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
    
//    MARK: PROVAS GET
    func getProvas() -> (populares: NSArray, recentes: NSArray){
        let first = ["Maratona ENEM","Resumão FUVEST","Rumo ao ITA","Mack Provas"]
        
        let second = ["Novos Testes", "Tendência ENEM", "Vai Cair", "Questões do ITA"]
        
        return (first, second)
    }
    
    func getAllProvas() ->NSArray{
        let query = PFQuery(className: "Questao")
        let questoes = query.findObjects() as AnyObject! as! NSArray
        return questoes
    }
    
//    MARK: PROVAS INSERIR
    func inserirProva(titulo: String, image: UIImage?, descricao: String, questoes: [PFObject], tags: [String], completionHandler: (NSErrorPointer) -> ()){
        let prova = PFObject(className: "Prova")
        prova.setObject(titulo, forKey: "Titulo")
        prova.setObject(descricao, forKey: "Descricao")
        prova.setObject(tags, forKey: "Tags")
        
        if(image != nil){
            prova.setObject(image!, forKey: "imagem")
        }
        
        let relationDisciplinas = prova.relationForKey("Disciplinas")
        let relationQuestoes = prova.relationForKey("Questoes")
        var disciplinas: [PFObject] = []
        
        //Adiciona relação para questões
        for questao in questoes{
            relationQuestoes.addObject(questao)
            
            let disciplina = questao.objectForKey("Disciplina") as! PFObject
            let newDisciplina = disciplina.objectForKey("Nome") as! String
            
            //Procura para ver se a disciplina já está adicionada na relação
            var find = false
            for disc in disciplinas{
                let oldDisciplina = disc.objectForKey("Nome") as! String
                if(oldDisciplina == newDisciplina){
                    find = true
                    break
                }
            }
            
            if(!find){
                disciplinas.append(disciplina)
            }
        }
        
        //Adiciona relação para disciplinas
        for disc in disciplinas{
            relationDisciplinas.addObject(disc)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            if(prova.save()){
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(&erro)
                })
                
                return
            }
            else{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro ao salvar. Tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao salvar.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente.", comment: "")
                ]
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(&erro)
                })
                return
            }
        })
    }
    
//    MARK: QUESTÃO AVALIAR
    func dislikeQuestao(questao: PFObject, idQuestao:String){
        let  queryQuestao = PFQuery(className: "Questao")
        queryQuestao.whereKey("objectId", equalTo: idQuestao)
        
        let questao  = queryQuestao.getFirstObject()
        var num = questao?.objectForKey("Dislikes") as! Int
        num++
        
        questao?.setObject(num, forKey: "Dislikes")
        questao?.saveInBackground()
    }
    
    func likeQuestao(questao:PFObject, idQuestao:String){
        
        let  queryQuestao = PFQuery(className: "Questao")
        queryQuestao.whereKey("objectId", equalTo: idQuestao)
        
        let questao  = queryQuestao.getFirstObject()
        var num = questao?.objectForKey("Likes") as! Int
        num++
        
        questao?.setObject(num, forKey: "Likes")
        questao?.saveInBackground()
    }
    
//    MARK: QUESTÃO GET
    func getLeastRatedQuestions() -> NSArray{
        let query = PFQuery(className: "Questao")
        query.limit = 10
        
        let array = query.findObjects()
        return array!
    }
    
    func getQuestoesByKeyword(keyword: String, completionHandler: (ParseManager, NSArray, NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.whereKey("Tags", containedIn: [keyword.simpleString()])
        query.orderByDescending("TimesUsed")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            guard let result = query.findObjects(&erro) else{
                //Não encontrou resultados
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    let auxArray = NSArray()
                    completionHandler(self, auxArray, erro)
                })
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                completionHandler(self, result, erro)
            })
            
            return
        })
    }
    
    func getQuestoesQuant(quantidade: Int){
        
        let object = PFQuery(className:"Questao" ).getFirstObject()
        print(object?.objectForKey("idNumber"))
    }
    
    func getQuestoesPredefinidas(){
        let userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: "n8wTIH5ZAo")
        let arrayUser = userQuery?.findObjects()
        
        let user = arrayUser?.last as! PFUser
        
        let query = PFQuery(className: "Questao")
        query.whereKey("Dono", equalTo: user)
    }
    
    func getQuestoes(disciplina: String, index: Int)-> NSArray{
        let query = PFQuery(className:"Questao")
        
        let array = query.findObjects()
        
        return array!
    }
    
    //    func getQuestaoEnemByDisciplina(disciplina: String, repetidas: NSArray) -> (alternativas: NSArray, enunciado: String, titulo: String, imagem: UIImage?){
    func getQuestaoEnemByDisciplina(disciplina: String, repetidas: [String]) -> PFObject?{
        //        let user = self.getUserById("C6f2xrLbkK")
        
        let query = PFQuery(className: "Questao")
        query.whereKey("Disciplina", equalTo: disciplina)
        //        query.whereKey("Dono", equalTo: user)
        query.limit = 1
        
        query.whereKey("objectId", notContainedIn: repetidas)
        
        query.findObjects()
        
        let arrayRetorno = query.findObjects()
        guard let questao = arrayRetorno?.last as? PFObject else{
            return nil
        }
        print(questao.objectForKey("Enunciado") as! String)
        
        return questao
        
        //        let enunciado = questao.objectForKey("Enunciado") as! String
        //        let titulo = questao.objectForKey("Descricao") as! String
        //        let img = questao.objectForKey("Imagem") as? UIImage
        //
        //        let arrayAlternativas = NSMutableArray()
        //
        //        arrayAlternativas.addObject(questao.objectForKey("AlternativaA")!)
        //        arrayAlternativas.addObject(questao.objectForKey("AlternativaB")!)
        //        arrayAlternativas.addObject(questao.objectForKey("AlternativaC")!)
        //        arrayAlternativas.addObject(questao.objectForKey("AlternativaD")!)
        //        arrayAlternativas.addObject(questao.objectForKey("AlternativaE")!)
        //        
        //        return (arrayAlternativas, enunciado, titulo, img)
    }
    
    func getQuestoesProva(disciplina:String, tag: String)->NSMutableArray{
        
        let query = PFQuery(className: "Simulado")
        query.whereKey("Disciplina", equalTo: disciplina)
        let arrayQuery = query.findObjects() as NSArray!
        
        
        let query1 = PFQuery(className: "Simulado")
        query1.whereKey("Tag", equalTo: tag)
        let arrayQuery2 = query1.findObjects()
        
        let arrayMu = NSMutableArray(array: arrayQuery)
        arrayMu.addObjectsFromArray(arrayQuery2!)
        return arrayMu
    }
    
//    MARK: QUESTÃO INSERIR
    func insertQuestao(titulo: String, disciplina: PFObject, tags: [String], enunciado: String, img: UIImage, alternativas: [String], completionHandler: (ParseManager, NSError?) -> ()){
        
        let questao = PFObject(className: "Questao")
        questao.setObject(PFUser.currentUser()!, forKey: "Dono")
        questao.setObject(titulo, forKey: "Descricao")
        questao.setObject(disciplina, forKey: "Disciplina")
        questao.setObject(enunciado, forKey: "Enunciado")
        
        var tagsLowerCase: [String] = []
        
        for obj in tags{
            let newTag = obj.simpleString()
            tagsLowerCase.append(newTag)
        }
        
        questao.setObject(disciplina, forKey: "Disciplina")
        
        questao.setObject(tagsLowerCase, forKey: "Tags")
        
        //        let patterImage = UIImage(named: "Login4")
        //        if (img != patterImage){
        //            questao.setObject(img, forKey: "Imagem")
        //        }
        
        questao.setObject(alternativas[0], forKey: "AlternativaA")
        questao.setObject(alternativas[1], forKey: "AlternativaB")
        questao.setObject(alternativas[2], forKey: "AlternativaC")
        questao.setObject(alternativas[3], forKey: "AlternativaD")
        questao.setObject(alternativas[4], forKey: "AlternativaE")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            if(questao.save()){
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(self, erro)
                })
                
                return
            }
            else{
                erro = NSError(domain: "ParseManager", code: 1, userInfo: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                return
            }
        })
    }
    
//    MARK: Register
    func registerUserTemp(newUsername: String, newPassword: String) -> Bool{
        let usernameLowerString = newUsername.lowercaseString
        let newUser = PFUser()
        newUser.username = usernameLowerString
        newUser.password = newPassword
        newUser.email = usernameLowerString
        newUser.setObject(usernameLowerString, forKey: "Nome")
        newUser.setObject("Brasil", forKey: "pais")
        newUser.setObject("Aluno", forKey: "ocupacao")
        newUser.setObject(true, forKey: "HasPassword")
        newUser.setObject(false, forKey: "FacebookLinked")
        
        newUser.signUp()
//        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
//            if(success){
//                return true
//            } else{
//                
//            }
//        }
        
        guard let _ = PFUser.currentUser() else{
            return false
        }
        
        return true
    }
    
    func registerUserDef(newPais: String, newOcupacao: String) -> Bool{
        guard let newUser = PFUser.currentUser() else{
            return false
        }
        
        newUser.setObject(newPais, forKey: "pais")
        newUser.setObject(newOcupacao, forKey: "ocupacao")
        
        return newUser.save()
    }
    
    func registerUserFacebook(email: String, name: String) -> Bool{
        let usernameLowerString = email.lowercaseString
        guard let newUser = PFUser.currentUser() else{
            return false
        }
        newUser.username = usernameLowerString
        newUser.email = usernameLowerString
        newUser.setObject(name, forKey: "Nome")
        newUser.setObject("Brasil", forKey: "pais")
        newUser.setObject("Aluno", forKey: "ocupacao")
        newUser.setObject(true, forKey: "FacebookLinked")
        newUser.setObject(false, forKey: "HasPassword")
        newUser.save()
        
        newUser.signUp()
        
        guard let _ = PFUser.currentUser() else{
            return false
        }
        
        return true
    }
    
//    MARK: USER GET
    func getUserById(userId: String) -> PFUser{
        let userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: userId)
        let arrayUser = userQuery?.findObjects()
        let user = arrayUser?.last as! PFUser
        
        return user
    }
    
//    MARK: USER UPDATE
    func updateUser(email: String, pais: String, ocupacao: String, completionHandler:(ParseManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Garante que o usuário está logado
            guard let user = PFUser.currentUser() else{
                //Usuário não logado
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Tente novamente", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Usuário retornou nulo.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente.", comment: "")
                ]
                erro = NSError(domain: "ParseManager", code: 3, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                
                return
            }
            
            //Verifica se o email já é o usado para este usuário
            if(email != user.email){
                //Email é diferente do atual
                let emailValid = self.checkEmail(email)
                
                if(!emailValid){
                    //O email já está sendo usado por outro usuário
                    let userInfo:[NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Já existe um usuário cadastrado com esse email.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email já usado.", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email.", comment: "")
                    ]
                    erro = NSError(domain: "ParseManager", code: 4, userInfo: userInfo)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self, erro)
                    })
                    
                    return
                }
            }
            
            user.setObject(email, forKey: "email")
            user.setObject(pais, forKey: "pais")
            user.setObject(ocupacao, forKey: "ocupacao")
            
            user.save(&erro)
            
            if(erro != nil){
                //Ocorreu um erro ao salvar
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Ocorreu um erro. Tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao salvar.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente, verifique sua conexão.", comment: "")
                ]
                erro = NSError(domain: "ParseManager", code: 5, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                
                return
            }
            
            //Salvo com sucesso
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(self, erro)
            })
            
            return
        })
    }
    
    
    
    func setNameForUser(name: String, user: PFUser) -> Bool{
        var erro = NSErrorPointer.init()
        user.setObject(name, forKey: "Nome")
        user.username = name
        user.save(erro)
        
        if(erro != NSErrorPointer.init()){
            return false
        }
        
        return true
    }
    
//    MARK: Validar
    func checkNickname(newName: String) -> Bool{
        let query = PFUser.query()
        query?.whereKey("username", equalTo: newName.lowercaseString)
        let object = query?.getFirstObject()
        
        return (object == nil)
    }
    
    func checkEmail(newEmail: String) -> Bool{
        let query = PFUser.query()
        query?.whereKey("email", equalTo: newEmail.lowercaseString)
        let object = query?.getFirstObject()
        
        return (object == nil)
    }
}
