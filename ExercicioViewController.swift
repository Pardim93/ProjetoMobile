//
//  ExercicioViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class ExercicioViewController: UIViewController {
    
    var flag = true
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgExercicio: UIImageView!
    
    
    @IBOutlet weak var txtExercicio: UITextView!
    var atual: Int = 0
    var arrayQuestao: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = self.getTitle()
    }
    
    func getTitle() -> String{
        var newTitle = "Questão \(atual) - "
        return newTitle
    }
    
    func getQuestaoData(){
        var arrayTemp = NSMutableArray()
        
        for obj in arrayTemp{
            //            let objString = o
        }
    }
    
    func createViews(){
        
    }
    
    @IBAction func muda(sender: AnyObject) {
        
        if(flag){
            
            txtExercicio.hidden = false
            imgExercicio.hidden = true
            flag = false
            
        }else{
            imgExercicio.hidden = false
            txtExercicio.hidden = true
            flag = true
            
        }
        
        
    }
    // MARK: Check
    func isImage() -> Bool{
        var flag = false
        return flag
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toExercise"){
            let nextExercise = segue.destinationViewController as! ExercicioViewController
            nextExercise.atual = self.atual++
        }
    }
}
