//
//  PerguntasAvaliacaoViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 10/28/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class PerguntasAvaliacaoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var strForTextView  = String()
    @IBOutlet weak var buttomDown: UIButton!
    @IBOutlet weak var buttomUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawBorders()
        self.textView.text = strForTextView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dislikeQuestao(sender: AnyObject) {
    }

    @IBAction func likeQuestao(sender: AnyObject) {
    }
    
    func drawBorders(){
        self.textView.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 6
        self.textView.clipsToBounds = true
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
