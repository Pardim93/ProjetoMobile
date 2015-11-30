//
//  ResultadoProvaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 04/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ResultadoProvaViewController: UITableViewController  {
    
    var auxQuestoes = AuxiliarQuestoes.singleton
    var singleton = QuestoesManager.singleton
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackButton()
        self.configHomeButton()
        self.tableView.reloadData()
        self.view.userInteractionEnabled = true
    }
    
    func configBackButton(){
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func configHomeButton(){
        let backButton = UIBarButtonItem(image: UIImage(named: "Home-30.png"), style: .Plain, target: self, action: "goHome")
        self.navigationItem.rightBarButtonItem = backButton
        
    }
    func goBack(){
        singleton.contRespostas--
    }
    
    func goHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyboard.instantiateInitialViewController()
        self.navigationController?.presentViewController(mainView!, animated: true, completion: nil)
        singleton.zerar()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auxQuestoes.questoesUsuario.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    
    
    //    func carregaQuestao(){
    //
    //        var arrayAlternativas = NSMutableArray()
    //
    //
    //
    //        while(arrayAlternativas.count < 5){
    //            let  rndNum = Int(arc4random_uniform(5))
    //            let letra = String(UnicodeScalar(65 + rndNum))
    //
    //            if(!arrayAlternativas.containsObject((self.auxQuestoes.questoesUsuario.objectForKey("Alternativa\(letra)"))!)){
    //                arrayAlternativas.addObject((questao?.objectForKey("Alternativa\(letra)"))!)
    //            }
    //
    //        }
    //    }
    //
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PerguntasTableViewCell
        print(cell.textLabel?.text)
        self.performSegueWithIdentifier("goToInfo", sender: self)
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exercicioCell") as! PerguntasTableViewCell
        cell.textLabel?.text = "Pergunta \(indexPath.row + 1)"
        cell.textLabel?.textAlignment = .Center
        cell.accessoryType = .DisclosureIndicator
        
        cell.textLabel!.font = UIFont (name: "Avenir Light", size: 18)

        
        let respostaCerta = (auxQuestoes.questoesCorretas[(indexPath.row)].objectForKey("AlternativaA") as? String)
        let respostaUsuario = auxQuestoes.questoesUsuario[indexPath.row] as! String
        cell.configImage()
        
        if(respostaCerta! == respostaUsuario){
            cell.imgCell?.image = UIImage(named:"rightAnswerIco")
        }else{
            cell.imgCell?.image = UIImage(named:"wrongAns")
        }
        
        return cell
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.singleton.limpaQuestoesSelecionadas()
        self.auxQuestoes.limpaArrayBool()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToInfo"){
            
            let upcoming = segue.destinationViewController as? ResultadoInfoViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let respostaUsuario = auxQuestoes.questoesUsuario[(indexPath?.row)!] as! String
            
            upcoming!.strResposta  = (auxQuestoes.questoesCorretas[(indexPath?.row)!].objectForKey("AlternativaA") as? String)!
            upcoming!.strEnunciado = (auxQuestoes.questoesCorretas[(indexPath?.row)!].objectForKey("Enunciado") as? String)!
            upcoming?.strUserResposta = respostaUsuario
            
            
            
            
        }
    }
}



