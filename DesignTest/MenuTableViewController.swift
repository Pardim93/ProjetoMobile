//
//  MenuTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 14/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController{
    
    let parseManager = ParseManager.singleton
    let logoffButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Menu"
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        let img = UIImage(named: "Blurry4")
//        self.view.backgroundColor = UIColor(patternImage: img!);
        self.view.backgroundColor = UIColor.newLightBlueColor()
        
//        self.configLogoffButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configActivityView()
    }
    
//    MARK: Config
    func configLogoffButton(){
        logoffButton.setImage(UIImage(named: "Shutdown-100"), forState: .Normal)
        logoffButton.frame = CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 70, 40, 40)
        logoffButton.addTarget(self, action: "showConfirmAlert", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(logoffButton)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    //MARK: Alert
    func showConfirmAlert(){
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você deseja mesmo sair?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.doLogout()
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    func doLogout(){
        self.disabeView()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        var unlogged = false
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            unlogged = self.parseManager.doLogout()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.enableView()
                if(unlogged){
                    self.goToHome()
                }
            }
        }
    }
    
    func goToHome(){
        self.enableView()
        let storyboard = UIStoryboard(name: "IPhoneLogin", bundle: NSBundle.mainBundle())
        let nextViewController: CustomNavigationViewController = storyboard.instantiateInitialViewController() as! CustomNavigationViewController
        self.navigationController!.presentViewController(nextViewController, animated: true, completion: nil)
    }
}
