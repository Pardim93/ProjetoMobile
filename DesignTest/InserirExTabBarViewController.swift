//
//  InserirExTabBarViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 24/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirExTabBarViewController: UITabBarController {
    
    let parseManager = ParseManager.singleton
//    let activityView = CustomActivityView()
    let segmented = UISegmentedControl(items: ["Informações", "Enunciado", "Alternativas"])
    var cont = 0
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
        
        let tituloView = self.viewControllers![0] as? InserirTituloTableViewController
        tituloView?.configDisciplinas()
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
//        segmented.tintColor = UIColor.newLightBlueColor()
//        segmented.tintColor = UIColor(red: 0/255, green: 121/255, blue: 1, alpha: 1.0)
        segmented.addTarget(self, action: "changeView", forControlEvents: .ValueChanged)
        
        self.view.addSubview(segmented)
    }

//    MARK: CheckStatus
    func checkTitulo() -> Bool{
        guard let titleView = self.viewControllers![0] as? InserirTituloTableViewController else{
            return false
        }
        
        return titleView.tituloValido()
    }
    
    func checkPalavraChave() -> Bool{
        guard let titleView = self.viewControllers![0] as? InserirTituloTableViewController else{
            return false
        }
        return titleView.palavrasChaveValidas()
    }
    
    func checkEnunciado() -> Bool{
        guard let enunciadoView = self.viewControllers![1] as? InserirEnunciadoTableViewController else{
            return false
        }
        return enunciadoView.enunciadoValido()
    }
    
    func checkAlternativa() -> Bool{
        guard let alternativaView = self.viewControllers![2] as? InserirExTableViewController else{
            return false
        }
        return alternativaView.alternativaValida()
    }
    
//    MARK: Button
    func goToNext(){
        let proxView = self.selectedIndex + 1
        self.selectedViewController = self.viewControllers![proxView]
        self.segmented.selectedSegmentIndex = proxView
    }
    
    func saveEx() {
        self.cancelViewsEditing()
        
        self.disabeView()
        
        if(!self.checkTitulo()){
            self.enableView()
            self.navigationController!.showAlert("Título inválido")
            return
        }
        
        if(!self.checkPalavraChave()){
            self.enableView()
            self.navigationController!.showAlert("Palavras chaves inválidas")
            return
        }
        
        if (!self.checkEnunciado()){
            self.enableView()
            self.navigationController!.showAlert("Enunciado inválido")
            return
        }
        
        if (!self.checkAlternativa()){
            self.enableView()
            self.navigationController!.showAlert("Alternativas inválidas")
            return
        }
        
        self.salvar()
    }
    
//    MARK: Segmented
    func changeView(){
        self.selectedViewController = self.viewControllers![segmented.selectedSegmentIndex]
    }
    
//    MARK: Salvar
    func salvar(){
        let tituloView = self.getTituloView()
        let enunciadoView = self.getEnunciadoView()
        let alternativaView = self.getAlternativaView()
        let img = enunciadoView.img
        let titulo = tituloView.titulo
        let disciplina = tituloView.disciplina
        let tags = tituloView.tags
        let enunciado = enunciadoView.enunciado
        let alternativas = alternativaView
        
        parseManager.insertQuestao(titulo, disciplina: disciplina, tags: tags, enunciado: enunciado, img: img, alternativas: alternativas) {(error) -> () in
            self.enableView()
            
            if(error != nil){
                self.navigationController!.showAlert("Ocorreu um erro. Tente novamente.")
                return
            }
            
            self.notificateSave()
        }
    }
    
    func getTituloView() -> (titulo: String, disciplina: PFObject, tags: [String]){
        let view = self.viewControllers![0] as! InserirTituloTableViewController
        
        let tituloCell = view.arrayCell.objectAtIndex(0) as! TituloTableViewCell
        let disciplinaCell = view.arrayCell.objectAtIndex(1) as! DisciplinaTableViewCell
        let palavrasChaveCell = view.arrayCell.objectAtIndex(2) as! PalavrasChaveTableViewCell
        
        let titulo = tituloCell.descricaoTextView.text!
        let disciplina = disciplinaCell.getDisciplina()
        let palavrasChave = palavrasChaveCell.getPalavrasChave()
        
        return (titulo, disciplina, palavrasChave)
    }
    
    func getEnunciadoView() -> (enunciado: String, img: UIImage?){
        let view = self.viewControllers![1] as! InserirEnunciadoTableViewController
        
        let enunciadoCell = view.arrayCell.objectAtIndex(0) as! EnunciadoTableViewCell
        let imagemCell = view.arrayCell.objectAtIndex(1) as! ImagemTableViewCell
        
        let enunciado = enunciadoCell.textView.text
        let img = imagemCell.getImage()
        
        return (enunciado, img)
    }
    
    func getAlternativaView() -> [String]{
        let view = self.viewControllers![2] as! InserirExTableViewController
        
        return view.getAlternativas()
    }
    
//    MARK: Notification
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
    
    func notificateSave(){
        self.cancelViewsEditing()
        
        let alertController = UIAlertController(title: "Simulandos", message: "Salvo com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.navigationItem.leftBarButtonItem = self.backItem
            self.navigationController?.popViewControllerAnimated(true)
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cancelViewsEditing(){
        for viewController in self.viewControllers!{
            viewController.view.endEditing(true)
        }
    }
}
