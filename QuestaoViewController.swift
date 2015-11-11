//
//  QuestaoViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class QuestaoViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var imgExercicio: UIImageView!
    @IBOutlet weak var txtEnunciado: UITextView!
    private var timer = NSTimer()
    private var auxData = AuxiliarData.singleton
    private var parseManager = ParseManager.singleton
    var questao = NSObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.checkFlag()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func thumbsUp(sender: AnyObject) {
    }
    //checa se é a primeira vez que a view carrega
    
    @IBAction func thumbsDown(sender: AnyObject) {
    }
    func checkFlag(){
        
        if(self.auxData.flag){
            timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "loadImage", userInfo: nil, repeats: true)
            self.configView()
        }

    }
    
    
    func configView(){
        self.questao = self.auxData.questao
        self.txtEnunciado.text = self.questao.valueForKey("Enunciado") as! String
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
