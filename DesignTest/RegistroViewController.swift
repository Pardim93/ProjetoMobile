//
//  RegistroViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var paisPicker: UIPickerView!
    @IBOutlet weak var aluno: UIButton!
    @IBOutlet weak var professor: UIButton!
    @IBOutlet weak var registrar: ZFRippleButton!
    
    let registerManager = RegisterManager.singleton
    let coreDataManager = CoreDataManager.singleton
    let activityView = CustomActivityView()
    var actual: UIButton?
    var paises: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        self.paisPicker.delegate = self
        self.paisPicker.dataSource = self
        
        self.configurePaises()
        self.configurePicker()
        self.configureButton()
        self.createBg()
        
        self.aluno.selected = true
        self.actual = self.aluno
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.createBlackView()
    }
    
//    MARK: Config
    func configurePaises(){
//        self.paises = ["EUA", "Portugal", "Brasil", "Japão", "Alemanha"]
        self.paises = self.coreDataManager.getPaises()
    }
    
    func configurePicker(){
        self.paisPicker.layer.borderColor = UIColor.clearColor().CGColor
        self.paisPicker.layer.borderWidth = 0.5
        self.paisPicker.layer.cornerRadius = 5
        
        for index in 0...paises.count{
            if(paises[index] == "Brazil"){
                self.paisPicker.selectRow(index, inComponent: 0, animated: false)
                break
            }
        }
    }
    
    func configActivityView(){
        self.activityView.center = self.view.center
        self.activityView.stopAnimating()
        self.view.addSubview(activityView)
    }
    
    func configureButton(){
        self.registrar.layer.borderColor = UIColor.clearColor().CGColor
        self.registrar.layer.borderWidth = 0.5
        self.registrar.layer.cornerRadius = 5
    }
    
    func createBg(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "Blurry4")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func createBlackView(){
        let alunoView = UIView()
        alunoView.backgroundColor = UIColor.blackColor()
        alunoView.alpha = 0.2
        alunoView.frame.size = CGSizeMake(140, 140)
        alunoView.layer.cornerRadius = 5
        alunoView.layer.borderWidth = 0.5
        alunoView.center.x = aluno.center.x
        alunoView.center.y = aluno.center.y + 10
        self.view.addSubview(alunoView)
        
        let professorView = UIView()
        professorView.backgroundColor = UIColor.blackColor()
        professorView.alpha = 0.2
        professorView.frame.size = CGSizeMake(140, 140)
        professorView.layer.cornerRadius = 5
        professorView.layer.borderWidth = 0.5
        professorView.center.x = professor.center.x
        professorView.center.y = professor.center.y + 10
        self.view.addSubview(professorView)
    }

//    MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paises.count
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return paises[row]
//    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = paises[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
//MARK: Button
    func getOcupacao() -> String{
        
        guard let newOcupacao = self.actual!.titleLabel!.text else{
            return ""
        }
        
        return newOcupacao
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        self.actual?.selected = false
        self.actual = sender
        sender.selected = true
    }
    
    @IBAction func registrar(sender: AnyObject) {
        self.disableView()
        
        let newOcupacao = self.getOcupacao()
        let newIndex = self.paisPicker.selectedRowInComponent(0)
        let newPais = self.paises[newIndex]
        
        if(newOcupacao == "") || (newPais == ""){
            self.navigationController!.showAlert("Ocorreu um erro. Tente novamente.")
            return
        }
        
        registerManager.tryFinishSignUp(newPais, ocupacao: newOcupacao) {(registerManager, error) -> () in
            self.enableView()
            if (error != nil){
                let msg = error?.localizedDescription
                self.navigationController!.showAlert(msg!)
                return
            }
            
            self.goToMain()
        }
    }
    
//    MARK: ViewStatus
    func enableView(){
        self.view.userInteractionEnabled = true
        self.activityView.stopAnimating()
    }
    
    func disableView(){
        self.view.userInteractionEnabled = false
        self.activityView.startAnimating()
    }
    
//    MARK: Navigation
    func goToMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController: SWRevealViewController = storyboard.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewController
        self.navigationController?.presentViewController(nextViewController, animated: true, completion: nil)
    }
}
