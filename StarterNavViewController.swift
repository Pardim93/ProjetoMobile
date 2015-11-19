 //
//  StarterNavViewController.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 11/19/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class StarterNavViewController: UINavigationController, UINavigationControllerDelegate, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationBar.backItem?.title = "testeeeee"
        self.navigationItem.setHidesBackButton(true, animated: false)

        
//        self.navigationBar.backIndicatorImage = UIImage(named: "backButton")
//        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButt")
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "butn", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButt")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "butn", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    }
    
    
    
    func a(){
        
    }
    
    func test(button:UIBarButtonItem){
        
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
