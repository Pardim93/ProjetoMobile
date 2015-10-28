//
//  ResultadoProvaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 04/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ResultadoProvaViewController: UITableViewController  {
    
    
    
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
        return singleton.respostasUsuario.count;
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PerguntasTableViewCell
        print(cell.textLabel?.text)
        self.performSegueWithIdentifier("goToInfo", sender: self)
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exercicioCell") as! PerguntasTableViewCell
        cell.textLabel?.text = "Pergunta \(indexPath.row + 1)"
        cell.textLabel?.textAlignment = .Center
        cell.accessoryType = .DisclosureIndicator

     
        
        let respostaCerta = (singleton.questoes[(indexPath.row)].objectForKey("AlternativaA") as? String)
        let respostaUsuario = singleton.respostasUsuario[indexPath.row] as! String
        cell.configImage()

        if(respostaCerta! == respostaUsuario){
            cell.imgCell?.image = UIImage(named:"rightAnswerIco")
        }else{
            cell.imgCell?.image = UIImage(named:"wrongAns")
        }

        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToInfo"){
            
            let upcoming = segue.destinationViewController as? ResultadoInfoViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let respostaUsuario = singleton.respostasUsuario[(indexPath?.row)!] as! String

            upcoming!.strResposta  = (singleton.questoes[(indexPath?.row)!].objectForKey("AlternativaA") as? String)!
            upcoming!.strEnunciado = (singleton.questoes[(indexPath?.row)!].objectForKey("Enunciado") as? String)!
            upcoming?.strUserResposta = respostaUsuario
            
            

            
        }
    }
}



