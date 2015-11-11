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
            
            do{
                let result = try query.findObjects()
                
                var disciplinas: [PFObject] = []
                
                for item in result{
                    disciplinas.append(item)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(disciplinas, erro)
                })
                return
            } catch{
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
        })
    }
    
    func getDisciplinaByNameSync(name: String) -> [PFObject]{
        let query = PFQuery(className: "Disciplina")
        
        var array: [PFObject]!
        
        do{
            array = try query.findObjects()
            return array
        } catch{
            return array
        }
    }
    
    func getDisciplinaByNameAsync(name: String, completionHandler:([PFObject], NSError?)->()){
        let query = PFQuery(className: "Disciplina")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let array = try query.findObjects()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let result = array
                    completionHandler(result, erro)
                })
                return
            } catch{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro na rede. Verifique sua conexão.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Erro ao buscar disciplina.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Verifique sua conexão e tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 8, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
//    MARK: Login/Logout
    func autoLogin() -> Bool{
        return (PFUser.currentUser() != nil)
    }
    
    func doLogin (email: String, senha: String) -> Bool{
        do{
            try PFUser.logInWithUsername(email.lowercaseString, password: senha)
            return (PFUser.currentUser() != nil)
        } catch{
            return false
        }
    }
    
    func doLogout() -> Bool{
        PFUser.logOut()
        
        return (PFUser.currentUser() == nil)
    }
    
//  MARK: Password Recover
    func retrievePassword(email: String, completionHandler:(ParseManager, NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            do{
                try PFUser.requestPasswordResetForEmail(email)
                //Senha recuperada com sucesso
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(self, erro)
                })
            }catch{
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
    func getProvasPopulares(completionHandler:(NSArray?, NSError?) -> ()){
        let query = PFQuery(className: "Prova")
        query.orderByDescending("Popularidade")
        query.includeKey("Autor")
        query.limit = 100
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Verifique se sua conexão funcionando.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email não utilizado ou conexão não funcionando.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email e/ou tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(nil, erro)
                })
                
                return
            }
        })
    }
    
    func getAllProvas() ->NSArray{
        let query = PFQuery(className: "Prova")
        query.includeKey("Disciplinas")
        query.includeKey("Questoes")
        query.includeKey("Autor")
        
        do{
            let questoes = try query.findObjects()
            return questoes
        } catch{
            return NSArray()
        }
    }
    
    func getProvasByKeyword(keyword: String, completionHandler:(NSArray?, NSError?) -> ()){
        let query = PFQuery(className: "Prova")
//        query.whereKey("Titulo", containsString: keyword)
        query.whereKey("Tags", containedIn: [keyword.simpleString(), keyword])
        query.includeKey("Autor")
        query.limit = 100
        query.orderByDescending("Popularidade")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Verifique se sua conexão funcionando.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email não utilizado ou conexão não funcionando.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email e/ou tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(nil, erro)
                })
                
                return
            }
        })
    }
    
//    MARK: PROVAS INSERIR
    func inserirProva(titulo: String, image: UIImage?, descricao: String, questoes: [PFObject], var tags: [String], completionHandler: (NSError?) -> ()){
        let prova = PFObject(className: "Prova")
        
        //Verifica se o usuário está logado
        guard let user = PFUser.currentUser() else{
            let erro = self.getError(305)
            completionHandler(erro)
            return
        }
        
        //Set autor
        prova.setObject(user, forKey: "Autor")
        
        //Set titulo
        prova.setObject(titulo, forKey: "Titulo")
        
        //Set descricao
        prova.setObject(descricao, forKey: "Descricao")
        
        //Set numQuestões
        prova.setObject(questoes.count, forKey: "NumQuestoes")
        
        //Set popularidade
        prova.setObject(10, forKey: "Popularidade")
        
        let relationDisciplinas = prova.relationForKey("Disciplinas")
        let relationQuestoes = prova.relationForKey("Questoes")
        var disciplinas: [PFObject] = []
        
        //Adiciona relação entre prova e questões
        for questao in questoes{
            //Para cada questao no array de questoes
            relationQuestoes.addObject(questao)
            
            let disciplina = questao.objectForKey("Disciplina") as! PFObject
            let newDisciplina = disciplina.objectForKey("Nome") as! String
            
            
            var find = false
            
            //Procura para ver se a disciplina já está relação entre prova e disciplinas
            for disc in disciplinas{
                //Para cada disciplina no array de disciplinas
                let oldDisciplina = disc.objectForKey("Nome") as! String
                if(oldDisciplina == newDisciplina){
                    //Se a disciplina já está no array
                    find = true
                    break
                }
            }
            
            if(!find){
                //Se a disciplina não está no array
                disciplinas.append(disciplina)
                
                for tag in tags{
                    //Para cada tag no array de tags
                    if(tag == newDisciplina){
                        //Se a disciplina já está no array de tags
                        find = true
                    }
                }
                
                if(!find){
                    //Se a disciplina não está no array de tags
                    tags.append(newDisciplina.simpleString())
                }
            }
        }
        
        //Set tags
        prova.setObject(tags, forKey: "Tags")
        
        //Adiciona relação para disciplinas
        for disc in disciplinas{
            relationDisciplinas.addObject(disc)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Set imagem
            if(image != nil){
                let newImageFile = PFFile(data: UIImageJPEGRepresentation(image!, 0.7)!)
                
                do{
                    try newImageFile?.save()
                    prova.setObject(newImageFile!, forKey: "Imagem")
                } catch{
                    let userInfo:[NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Erro ao salvar. Tente novamente.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao salvar.", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente.", comment: "")
                    ]
                    erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                }
            }
            
            //Salva prova
            do{
                try prova.save()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(erro)
                })
                
                return
            } catch{
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Erro ao salvar. Tente novamente.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao salvar.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente.", comment: "")
                ]
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
        })
    }
    
//    MARK: QUESTÃO AVALIAR
    func dislikeQuestao(questao: PFObject, idQuestao:String){
        let  queryQuestao = PFQuery(className: "Questao")
        queryQuestao.includeKey("Disciplina")
        queryQuestao.includeKey("Autor")
        queryQuestao.whereKey("objectId", equalTo: idQuestao)
        
        do{
            let questao = try queryQuestao.getFirstObject()
            var num = questao.objectForKey("Dislikes") as! Int
            num++
            questao.setObject(num, forKey: "Dislikes")
            questao.saveInBackground()
        } catch{
            return
        }
    }
    
    func likeQuestao(questao:PFObject, idQuestao:String){
        
        let  queryQuestao = PFQuery(className: "Questao")
        queryQuestao.includeKey("Disciplina")
        queryQuestao.includeKey("Autor")
        queryQuestao.whereKey("objectId", equalTo: idQuestao)
        
        do{
            let questao = try queryQuestao.getFirstObject()
            var num = questao.objectForKey("Likes") as! Int
            num++
            questao.setObject(num, forKey: "Likes")
            questao.saveInBackground()
        } catch{
            return
        }
    }
    
//    MARK: QUESTÃO GET
    func getLeastRatedQuestions() -> NSArray{
        let query = PFQuery(className: "Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.limit = 10
        
        var array: [PFObject] = []
        
        do{
            array = try query.findObjects()
            return array
        } catch{
            return array
        }
    }
    
    func getQuestoesPopulares(completionHandler: (NSArray, NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.orderByDescending("TimesUsed")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch{
                //Não encontrou resultados
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Verifique se seu email está funcionando e sua conexão funcionando.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email não utilizado ou conexão não funcionando.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email e/ou tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(NSArray(), erro)
                })
                
                return
            }
        })
    }
    
    func getQuestoesByKeyword(keyword: String, completionHandler: (NSArray, NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.whereKey("Tags", containedIn: [keyword.simpleString()])
        query.orderByDescending("TimesUsed")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch{
                //Não encontrou resultados
                let userInfo:[NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Verifique se seu email está funcionando e sua conexão funcionando.", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Email não utilizado ou conexão não funcionando.", comment: ""),
                    NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Digite um novo email e/ou tente novamente.", comment: "")
                ]
                
                erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    let auxArray = NSArray()
                    completionHandler(auxArray, erro)
                })
                
                return
            }
        })
    }
    
    func getQuestoesQuant(quantidade: Int){
        
//        do{
//            let object = try PFQuery(className: "Questao").getFirstObject()
//        } catch{
//            
//        }
        
//        let object = PFQuery(className:"Questao" ).getFirstObject()
//        print(object?.objectForKey("idNumber"))
    }
    
    func getQuestoesPredefinidas(){
        let userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: "n8wTIH5ZAo")
        
        do{
            let arrayUser = try userQuery!.findObjects()
            
            let user = arrayUser.last as! PFUser
            
            let query = PFQuery(className: "Questao")
            query.includeKey("Disciplina")
            query.includeKey("Autor")
            query.whereKey("Dono", equalTo: user)
        } catch{
            
        }
    }
    
    func getQuestoes(disciplina: String, index: Int)-> NSArray{
        let query = PFQuery(className:"Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        
        var array: [PFObject] = []
        
        do{
            array = try query.findObjects()
            
            return array
        } catch{
            return array
        }
    }
    
    //    func getQuestaoEnemByDisciplina(disciplina: String, repetidas: NSArray) -> (alternativas: NSArray, enunciado: String, titulo: String, imagem: UIImage?){
    func getQuestaoEnemByDisciplina(disciplina: String, repetidas: [String]) -> PFObject?{
        //        let user = self.getUserById("C6f2xrLbkK")
        
        let query = PFQuery(className: "Questao")
        query.whereKey("Disciplina", equalTo: disciplina)
        //        query.whereKey("Dono", equalTo: user)
        query.limit = 1
        
        query.whereKey("objectId", notContainedIn: repetidas)
        
//        query.findObjects()
        do{
            let arrayRetorno = try query.findObjects()
            guard let questao = arrayRetorno.last else{
                return nil
            }
            
            return questao
        } catch{
            return nil
        }
//        guard let questao = arrayRetorno?.last as? PFObject else{
//            return nil
//        }
//        print(questao.objectForKey("Enunciado") as! String)
//        
//        return questao
        
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
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.whereKey("Disciplina", equalTo: disciplina)
        
        do{
            let arrayQuery = try query.findObjects()
            
            let query1 = PFQuery(className: "Simulado")
            query1.whereKey("Tag", equalTo: tag)
            let arrayQuery2 = try query1.findObjects()
            
            let arrayMu = NSMutableArray(array: arrayQuery)
            arrayMu.addObjectsFromArray(arrayQuery2)
            return arrayMu
        } catch{
            return NSMutableArray()
        }
    }
    
//    MARK: QUESTÃO INSERIR
    func insertQuestao(titulo: String, disciplina: PFObject, tags: [String], enunciado: String, img: UIImage?, alternativas: [String], completionHandler: (NSError?) -> ()){
        
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
        
        questao.setObject(alternativas[0], forKey: "AlternativaA")
        questao.setObject(alternativas[1], forKey: "AlternativaB")
        questao.setObject(alternativas[2], forKey: "AlternativaC")
        questao.setObject(alternativas[3], forKey: "AlternativaD")
        questao.setObject(alternativas[4], forKey: "AlternativaE")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Set imagem
            if(img != nil){
                let newImageFile = PFFile(data: UIImageJPEGRepresentation(img!, 0.7)!)
                
                do{
                    try newImageFile?.save()
                    questao.setObject(newImageFile!, forKey: "imagem")
                } catch{
                    let userInfo:[NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("Erro ao salvar. Tente novamente.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Ocorreu um erro ao salvar.", comment: ""),
                        NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString("Tente novamente.", comment: "")
                    ]
                    erro = NSError(domain: "ParseManager", code: 6, userInfo: userInfo)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                }
            }
            
            do{
                try questao.save()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(erro)
                })
                
                return
            } catch{
                erro = NSError(domain: "ParseManager", code: 1, userInfo: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
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
        
        do{
            try newUser.signUp()
            
            return (PFUser.currentUser() != nil)
        } catch{
            return false
        }
    }
    
    func registerUserDef(newPais: String, newOcupacao: String) -> Bool{
        guard let newUser = PFUser.currentUser() else{
            return false
        }
        
        newUser.setObject(newPais, forKey: "pais")
        newUser.setObject(newOcupacao, forKey: "ocupacao")
        
        do{
            try newUser.save()
            return true
        } catch{
            return false
        }
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
        do{
            try newUser.save()
            try newUser.signUp()
            
            return true
        } catch{
            return false
        }
    }
    
//    MARK: USER GET
    func getUserById(userId: String) -> PFUser{
        let userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: userId)
        
        do{
            let arrayUser = try userQuery?.findObjects()
            let user = arrayUser?.last as! PFUser
        
            return user
        } catch{
            return PFUser()
        }
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
            
            do{
                try user.save()
                
                //Salvo com sucesso
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self, erro)
                })
                
                return
            } catch{
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
        })
    }
    
    
    
    func setNameForUser(name: String, user: PFUser) -> Bool{
        user.setObject(name, forKey: "Nome")
        user.username = name
        
        do{
            try user.save()
            return true
        } catch{
            return false
        }
    }
    
//    MARK: Validar
    func checkNickname(newName: String) -> Bool{
        let query = PFUser.query()
        query?.whereKey("username", equalTo: newName.lowercaseString)
        
        do{
            let object = try query?.getFirstObject()
            return object == nil
        } catch{
            return true
        }
    }
    
    func checkEmail(newEmail: String) -> Bool{
        let query = PFUser.query()
        query?.whereKey("email", equalTo: newEmail.lowercaseString)
        
        do{
            let object = try query?.getFirstObject()
            return (object == nil)
        } catch{
            return true
        }
    }
}
