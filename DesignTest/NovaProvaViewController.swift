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
//    let activityView = CustomActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeField.delegate = self
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

        self.performSelector("goToNextView", withObject: nil, afterDelay: 1.0)
        
        return
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
