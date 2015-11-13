//
//  AvaliacaoEnunciadoViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/9/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class AvaliacaoEnunciadoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var imgExercicio: UIImageView!
    @IBOutlet weak var txtEnunciado: UITextView!
    private var timer = NSTimer()
    private var auxData = AuxiliarData.singleton
    private var parseManager = ParseManager.singleton
    var questao = NSObject()
    
    @IBAction func thumbsUp(sender: AnyObject) {
//        parseManager.likeQuestao(self.auxData.objectId)
    }
 
    @IBAction func thumbsDown(sender: AnyObject) {
//        parseManager.dislikeQuestao(self.auxData.objectId)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.auxData.flag){
          timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "loadImage", userInfo: nil, repeats: true)
            self.configView()
        
            
        }
        // Do any additional setup after loading the view.
    }
    
   override func  `self`() -> Self {
        return self
    }
    
    func configView(){
        self.questao = self.auxData.questao
        self.txtEnunciado.text = self.questao.valueForKey("Enunciado") as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadImage(){
        if(self.auxData.imgIsReady){
            self.imgExercicio.image = auxData.returnImg()
            timer.invalidate()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
