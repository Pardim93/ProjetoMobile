//
//  InserirProvaTabBarViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirProvaTabBarViewController: UITabBarController {
    
    let parseManager = ParseManager.singleton
    let inserirQuestoesManager = InserirQuestoesProvaManager.singleton
    let segmented = UISegmentedControl(items: ["Capa", "Descrição", "Procurar", "Questões"])
    var backItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.hidden = true
        self.configSegmented()
        
        self.configBackButton()
        self.configProxButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.configBackButton()
//        self.configProxButton()
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
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "prepareToSave")
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
    
    func prepareToSave(){
        self.disabeView()
        
        if(!self.checkTitulo()){
            self.enableView()
            self.navigationController?.showAlert("Título inválido")
            return
        }
        
        if(!self.checkDescricao()){
            self.enableView()
            self.navigationController?.showAlert("Descrição inválida")
            return
        }
        
        if(!self.checkDescricao()){
            self.enableView()
            self.navigationController?.showAlert("Descrição inválida")
            return
        }
        
        if(!self.checkPalavrasChave()){
            self.enableView()
            self.navigationController?.showAlert("Tags inválidas")
            return
        }
        
        if(!self.checkQuestoes()){
            self.enableView()
            self.navigationController?.showAlert("Número de questões inválido. Mínimo 5 e máximo 90")
            return
        }
        
        self.save()
    }
    
//    MARK: Check
    func checkTitulo() -> Bool{
        let tituloView = self.viewControllers![0] as! InserirTituloProvaTableViewController
        return tituloView.checkTitulo()
    }
    
    func checkImagem() -> Bool{
        let tituloView = self.viewControllers![0] as! InserirTituloProvaTableViewController
        return tituloView.checkImagem()
    }
    
    func checkDescricao() -> Bool{
        let descricaoView = self.viewControllers![1] as! InserirDescricaoProvaTableViewController
        return descricaoView.checkDescricao()
    }
    
    func checkPalavrasChave() -> Bool{
        let descricaoView = self.viewControllers![1] as! InserirDescricaoProvaTableViewController
        return descricaoView.checkTags()
    }
    
    func checkQuestoes() -> Bool{
        let questoesView = self.viewControllers![3] as! InserirAdicionadasQuestoesTableViewController
        return questoesView.checkQuestoes()
    }

//    MARK: Save
    func save(){
        let tituloView = self.viewControllers![0] as! InserirTituloProvaTableViewController
        let descricaoView = self.viewControllers![1] as! InserirDescricaoProvaTableViewController
        let questoesView = self.viewControllers![3] as! InserirAdicionadasQuestoesTableViewController
        
        let titulo = tituloView.getTitulo()
        let img: UIImage? = tituloView.getCapa()
        
        let descricao = descricaoView.getDescricao()
        let tags = descricaoView.getTags()
        
        let questoes = questoesView.getQuestoes()
        
        self.disabeView()
        parseManager.inserirProva(titulo, image: img, descricao: descricao, questoes: questoes, tags: tags) { (erro) -> () in
            self.enableView()
            if(erro == nil){
                self.notificateSave()
                return
            }
            else{
                self.navigationController?.showAlert("Ocorreu um erro. Tente novamente")
            }
        }
    }
    
//    MARK: Segmented
    func changeView(){
        self.selectedViewController = self.viewControllers![segmented.selectedSegmentIndex]
    }
    
//    MARK: Alert
    func notificateSave(){
        self.cancelViewsEditing()
        
        let alertController = UIAlertController(title: "Vestibulandos", message: "Salvo com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.navigationItem.leftBarButtonItem = self.backItem
            self.navigationController?.popViewControllerAnimated(true)
            })
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func notificateConfirmation(){
        self.cancelViewsEditing()
        
        let alertController = UIAlertController(title: "Vestibulandos", message: "Você perderá o que foi escrito até agora. Deseja continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.navigationItem.leftBarButtonItem = self.backItem
            self.inserirQuestoesManager.cleanAll()
            self.navigationController?.popViewControllerAnimated(true)
            })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cancelViewsEditing(){
        for viewController in self.viewControllers!{
            viewController.view.endEditing(true)
        }
    }
}
