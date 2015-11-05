//
//  InserirProvaTabBarViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirProvaTabBarViewController: UITabBarController {
    
    let segmented = UISegmentedControl(items: ["Capa", "Descrição", "Procurar", "Questões"])
//    let activityView = CustomActivityView()
    var backItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.hidden = true
        self.configSegmented()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configBackButton()
        self.configProxButton()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
    func configBackButton(){
        backItem = self.navigationItem.leftBarButtonItem
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back-44"), style: .Plain, target: self, action: "notificateConfirmation")
        backButton.action = "notificateConfirmation"
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func configProxButton(){
        let proxButton = UIBarButtonItem(title: "Proximo", style: .Plain, target: self, action: "goToNext")
        self.navigationItem.rightBarButtonItem = proxButton
    }
    
    func configSaveButton(){
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveEx")
        self.navigationItem.rightBarButtonItem = buttonSave
    }
    
    func configSegmented(){
        segmented.frame = CGRectMake(-2.5, 0, self.view.frame.width+5, 40)
        segmented.selectedSegmentIndex = 0
        segmented.backgroundColor = UIColor.whiteColor()
        segmented.tintColor = UIColor.newLightBlueColor()
        segmented.addTarget(self, action: "changeView", forControlEvents: .ValueChanged)
        
        self.view.addSubview(segmented)
    }
    
//    MARK: Button
    func goToNext(){
        let proxView = self.selectedIndex + 1
        self.selectedViewController = self.viewControllers![proxView]
        self.segmented.selectedSegmentIndex = proxView
    }
    
    func saveEx(){
        print("Salvar")
    }

//    MARK: Segmented
    func changeView(){
        self.selectedViewController = self.viewControllers![segmented.selectedSegmentIndex]
    }
    
//    MARK: Alert
    func notificateConfirmation(){
        self.cancelViewsEditing()
        
        let alertController = UIAlertController(title: "Simulandos", message: "Você perderá o que foi escrito até agora. Deseja continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.navigationItem.leftBarButtonItem = self.backItem
            self.navigationController?.popViewControllerAnimated(true)
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
//    MARK: View
//    func enableView(){
//        self.view.userInteractionEnabled = true
//        self.activityView.stopAnimating()
//    }
    
//    func disabeView(){
//        self.view.userInteractionEnabled = false
//        self.activityView.startAnimating()
//    }
    
    func cancelViewsEditing(){
        for viewController in self.viewControllers!{
            viewController.view.endEditing(true)
        }
    }
}
