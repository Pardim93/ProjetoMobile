//
//  NovaProvaViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class NovaProvaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timeField: UITextField!
    
    let questaoManager = QuestoesManager.singleton
    var parseManager = ParseManager.singleton
    var auxQuestoes = AuxiliarQuestoes.singleton
//    let activityView = CustomActivityView()
    var prova: [PFObject] = []
     var arrayQuestoes:[PFObject] = []
    var questao = NSObject()
    
    
    func getRandomProva(){
        
        parseManager.getProvasPopulares { (result, error) -> () in
           
            
            if(error == nil){
                self.prova = result
                let maxValue = UInt32(self.prova.count)
                let randomIndex = Int(arc4random_uniform(maxValue))
                print(self.prova.count * 2)
              
                print(self.questao)
                let relation = self.prova[randomIndex].relationForKey("Questoes")
                
                // generate a query based on that relation
                let query = relation.query()
        
                 self.arrayQuestoes = try! (query?.findObjects())!
                
          
                print(self.arrayQuestoes)
                
                
                self.auxQuestoes.questao = self.arrayQuestoes[0]
                print(self.auxQuestoes.questao.valueForKey("Enunciado"))
                self.auxQuestoes.objectId = self.arrayQuestoes[0].objectId!
                self.auxQuestoes.indexQuestaoSelecionada = 1
               
                
//                self.navigationController?.presentViewController(newView, animated: true, completion: nil)
//                
//                
//                
//                newView.rearViewController.setValue(questoes, forKey: "myArray")
//                
//                QuestoesManager.singleton.tamanhoDasQuestoes(questoes.count)

               
             
            }
         
        }
        
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeField.delegate = self
        self.getRandomProva()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ////MARK: TextField
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    //        var result = true
    //
    //        let prospectiveText = (textField.text)!.stringByReplacingCharactersInRange(range, withString: string)
    //
    //        if (!string.isEmpty){
    //            let max4Characters = count(prospectiveText) <= 3
    //
    //            let lowerThan181 = (prospectiveText as NSString).doubleValue <= 180
    //
    //            result = max4Characters && lowerThan181
    //        }
    //
    //        return result
    //    }
    
    //    MARK: View
//    func enableView(){
//        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
//    }
//    
//    func disabeView(){
//        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
//        self.activityView.hidden = false
//    }
    
    //    MARK: Button
    
    @IBAction func goToEx(sender: AnyObject) {
        self.disabeView()
        let newView = storyboard!.instantiateViewControllerWithIdentifier("QuestaoSWReveal") as! SWRevealViewController
        
        self.auxQuestoes.indexQuestaoSelecionada = 1
        
        self.navigationController?.presentViewController(newView, animated: true, completion: nil)
        
        
        
        
        QuestoesManager.singleton.tamanhoDasQuestoes(self.arrayQuestoes.count)
        
        
        
        newView.rearViewController.setValue(self.arrayQuestoes, forKey:"myArray")

//        self.performSelector("goToNextView", withObject: nil, afterDelay: 1.0)
//        
//        return
    }
    
    func goToNextView(){
        self.performSegueWithIdentifier("goToEx", sender: self)
    }
    // MARK: - Navigation
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "goToEx"){
            self.disabeView()
        }
        
        return false
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if(segue.identifier == "goToEx") {
            
            
          
            
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.questaoManager.zerar()
                self.questaoManager.totalQuestoes = 30
                self.questaoManager.predefinido = true
                self.questaoManager.disciplinas = ["Matematica", "Português", "Geografia", "Inglês", "História"]
                self.questaoManager.calcularQuestoes()
//            })
            
            return
        }
        
        return
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.enableView()
    }
}
