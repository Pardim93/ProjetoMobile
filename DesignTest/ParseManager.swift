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
    
//    MARK: DISCIPLINA INSERIR
    func criarDenunciaProva(prova: PFObject, completionHandler: (NSError?) -> ()){
        var erro: NSError?
        
        guard let user = PFUser.currentUser() else{
            erro = self.getError(ParseError.UnloggedUser)
            
            completionHandler(erro)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let relation = prova.relationForKey("Denuncias")
            let newDenuncia = PFObject(className: "DenunciaProva")
            newDenuncia.setObject(user, forKey: "Autor")
            newDenuncia.setObject(prova, forKey: "Prova")
            
            do{
                try newDenuncia.save()
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
            
            relation.addObject(newDenuncia)
            
            do{
                try prova.save()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
        })
    }
    
    func criarDenunciaQuestao(questao: PFObject, completionHandler: (NSError?) -> ()){
        var erro: NSError?
        
        guard let user = PFUser.currentUser() else{
            erro = self.getError(ParseError.UnloggedUser)
            
            completionHandler(erro)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let relation = questao.relationForKey("Denuncias")
            let newDenuncia = PFObject(className: "DenunciaQuestao")
            newDenuncia.setObject(user, forKey: "Autor")
            newDenuncia.setObject(questao, forKey: "Questao")
            
            do{
                try newDenuncia.save()
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
            
            relation.addObject(newDenuncia)
            
            do{
                try questao.save()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
        })
    }
    
    func criarDenunciaUsuario(denunciado: PFUser, completionHandler: (NSError?) -> ()){
        var erro: NSError?
        
        guard let user = PFUser.currentUser() else{
            erro = self.getError(ParseError.UnloggedUser)
            
            completionHandler(erro)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let relation = denunciado.relationForKey("Denuncias")
            let newDenuncia = PFObject(className: "DenunciaUsuario")
            newDenuncia.setObject(user, forKey: "Autor")
            newDenuncia.setObject(denunciado, forKey: "Denunciado")
            
            do{
                try newDenuncia.save()
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
            
            relation.addObject(newDenuncia)
            
            do{
                try denunciado.save()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
        })
    }
    
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
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getDisciplinasByArrayProvas(provas: [PFObject], completionHandler: ([String], NSError?) -> ()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var discArray: [String] = []
            var erro: NSError?
            
            for prova in provas{
                let discRelation = prova.objectForKey("Disciplinas") as! PFRelation
                let query = discRelation.query()
                
                do{
                    let result = try query?.findObjects()
                    
                    var newText = ""
                    for disc in result!{
                        let disciplina = disc
                        let discString = disciplina.objectForKey("Nome")
                        newText += "\(discString!) - "
                    }
                    
                    newText = String(newText.characters.dropLast())
                    newText = String(newText.characters.dropLast())
                    
                    discArray.append(newText)
                } catch let externalError as NSError{
                    //Expected: -1, 1, 100
                    let errorCode = externalError.code
                    erro = self.getErrorForCode(errorCode)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler([], erro)
                    })
                    return
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(discArray, erro)
            })
            return
        })
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
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
//    MARK: IMAGEM GET
    func getImgForQuestao(questao: PFObject, completionHandler: (UIImage?, NSError?) -> ()){
        
        var img: UIImage?
        var erro: NSError?
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            guard let newImage = questao.objectForKey("Imagem") as? PFFile else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(img, erro)
                })
                return
            }
            
            do{
                let newData = try newImage.getData()
                img = UIImage(data: newData)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(img, erro)
                })
                return
            } catch let externalError as NSError{
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(img, erro)
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
    func retrievePassword(email: String, completionHandler:(NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            do{
                try PFUser.requestPasswordResetForEmail(email)
                //Senha recuperada com sucesso
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(erro)
                })
            }catch let externalError as NSError{
                //Falha ao recuperar senha
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
    })
}

//    MARK: PROVAS GET
    func getProvasByAutor(autor: PFUser, completionHandler: ([PFObject], NSError?) -> ()){
        let query = PFQuery(className: "Prova")
        query.orderByDescending("Popularidade")
        query.includeKey("Autor")
        query.limit = 100
        query.whereKey("Autor", equalTo: autor)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao buscar provas populares
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getProvasPopulares(completionHandler:([PFObject], NSError?) -> ()){
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
            } catch let externalError as NSError{
                //Falha ao buscar provas populares
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getProvasRecentes(completionHandler: ([PFObject], NSError?) -> ()){
        let query = PFQuery(className: "Prova")
        query.orderByDescending("createdAt")
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
            } catch let externalError as NSError{
                //Falha ao buscar provas recentes
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getAllProvas() ->NSArray{
        let query = PFQuery(className: "Prova")
        query.includeKey("Questoes")
        query.includeKey("Autor")
        
        do{
            let questoes = try query.findObjects()
            return questoes
        } catch{
            return NSArray()
        }
    }
    
    func getProvasByKeyword(keyword: String, completionHandler:([PFObject], NSError?) -> ()){
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
            } catch let externalError as NSError{
                //Falha ao buscar provas
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
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
            let erro = self.getError(ParseError.UnloggedUser)
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            let relationDisciplinas = prova.relationForKey("Disciplinas")
            let relationQuestoes = prova.relationForKey("Questoes")
            var disciplinas: [PFObject] = []
            
            //Adiciona relação entre prova e questões
            for questao in questoes{
                //Para cada questao no array de questoes
                
                questao.incrementKey("TimesUsed")
                
                do{
                    try questao.save()
                } catch let externalError as NSError{
                    //Falha ao salvar a questão
                    //Expected: -1, 1, 100
                    let errorCode = externalError.code
                    erro = self.getErrorForCode(errorCode)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                    return
                }
                
                relationQuestoes.addObject(questao)
                
                let disciplina = questao.objectForKey("Disciplina") as! PFObject
                let nomeDisciplina = disciplina.objectForKey("Nome") as! String
                
                var find = false
                
                //Procura para ver se a disciplina já está relação entre prova e disciplinas
                for disc in disciplinas{
                    //Para cada disciplina no array de disciplinas
                    let oldDisciplina = disc.objectForKey("Nome") as! String
                    if(oldDisciplina == nomeDisciplina){
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
                        if(tag == nomeDisciplina){
                            //Se a disciplina já está no array de tags
                            find = true
                        }
                    }
                    
                    if(!find){
                        //Se a disciplina não está no array de tags
                        tags.append(nomeDisciplina.simpleString())
                    }
                }
            }
            
            //Set tags
            prova.setObject(tags, forKey: "Tags")
            
            //Adiciona relação para disciplinas
            for disc in disciplinas{
                relationDisciplinas.addObject(disc)
            }
            
            //Set imagem
            if(image != nil){
                let newImageFile = PFFile(data: UIImageJPEGRepresentation(image!, 0.7)!)
                
                do{
                    try newImageFile?.save()
                    prova.setObject(newImageFile!, forKey: "Imagem")
                } catch let externalError as NSError{
                    //Falha ao buscar provas
                    //Expected: -1, 1, 100
                    let errorCode = externalError.code
                    erro = self.getErrorForCode(errorCode)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                    return
                }
            }
            
            //Salva prova
            do{
                try prova.save()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao salvar a prova
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
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
    
//    MARK: QUESTAO DELETE
    func deleteQuestao(questao: PFObject, completionHandler: (NSError?) -> ()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                try questao.delete()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            } catch let externalError as NSError{
                //Falha ao deletar a questão
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                return
            }
            
        })
    }
    
//    MARK: QUESTÃO GET
    func getQuestoesByAutor(autor: PFUser, completionHandler: ([PFObject], NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.whereKey("Dono", equalTo: autor)
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao buscar as questões
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getQuestoesByProva(prova: PFObject, completionHandler: ([PFObject], NSError?) -> ()){
        let relationForQuestoes = prova.relationForKey("Questoes")
        let query = relationForQuestoes.query()
        query!.includeKey("Disciplina")
        query!.includeKey("Autor")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query?.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result!, erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao buscar as questões
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
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
    
    func getQuestoesPopulares(completionHandler: ([PFObject], NSError?) -> ()){
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
            } catch let externalError as NSError{
                //Falha ao buscar as questões
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getQuestoesRecentes(completionHandler: ([PFObject], NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.orderByDescending("createdAt")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao buscar as questões
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
                })
                return
            }
        })
    }
    
    func getQuestoesByKeyword(keyword: String, completionHandler: ([PFObject], NSError?) -> ()){
        let query = PFQuery(className: "Questao")
        query.includeKey("Disciplina")
        query.includeKey("Autor")
        query.whereKey("Tags", containedIn: [keyword.simpleString(), keyword])
        query.orderByDescending("TimesUsed")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            do{
                let result = try query.findObjects()
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(result, erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao buscar as questões
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler([], erro)
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
        questao.setObject(0, forKey: "TimesUsed")
        questao.setObject(0, forKey: "Likes")
        questao.setObject(0, forKey: "Dislikes")
        
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
                } catch let externalError as NSError{
                    //Falha ao salvar a imagem
                    //Expected: -1, 1, 100
                    let errorCode = externalError.code
                    erro = self.getErrorForCode(errorCode)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                    return
                }
            }
            
            do{
                try questao.save()
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    completionHandler(erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao salvar a questão
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
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
        newUser.setObject(false, forKey: "showEmail")
        
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
        newUser.setObject(false, forKey: "showEmail")
        
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
    func updateUser(email: String, pais: String, ocupacao: String, showEmail: Bool, completionHandler:(NSError?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro: NSError?
            
            //Garante que o usuário está logado
            guard let user = PFUser.currentUser() else{
                //Usuário não logado
                erro = self.getError(ParseError.UnloggedUser)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                
                return
            }
            
            //Verifica se o email já é o usado para este usuário
            if(email != user.email){
                //Email é diferente do atual
                let emailValid = self.checkEmail(email)
                
                if(!emailValid){
                    //O email já está sendo usado por outro usuário
                    erro = self.getError(ParseError.RegisteredEmail)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(erro)
                    })
                    
                    return
                }
            }
            
            user.setObject(email, forKey: "email")
            user.setObject(pais, forKey: "pais")
            user.setObject(ocupacao, forKey: "ocupacao")
            user.setObject(showEmail, forKey: "showEmail")
            
            do{
                try user.save()
                
                //Salvo com sucesso
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
                })
                
                return
            } catch let externalError as NSError{
                //Falha ao salvar a questão
                //Expected: -1, 1, 100
                let errorCode = externalError.code
                erro = self.getErrorForCode(errorCode)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(erro)
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
