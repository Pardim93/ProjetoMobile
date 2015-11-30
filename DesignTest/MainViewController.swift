//
//  MainViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
//    Itens
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var inserirQuestaoButton: ZFRippleButton!
    @IBOutlet weak var inserirProvaButton: ZFRippleButton!
    @IBOutlet weak var estudarProvaButton: ZFRippleButton!
    
    
    let parseManager = ParseManager.singleton
    let titles = ["Maratona ENEM","Resumão FUVEST","Mack Provas", "#EUQUEROUSP"]
    var arrayImg: [UIImage?] = []
    var provas: [PFObject] = []
    var auxQuestoes = AuxiliarQuestoes.singleton
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSideBar()
        self.configProvas()
        self.configCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.userInteractionEnabled = true
        
        self.configButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }

//    MARK: Config
    func configureSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func configCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.layer.borderWidth = 0.5
    }
    
    func configProvas(){
        parseManager.getProvasByDescending("Popularidade", withLimit: 10) { (result, error) -> () in
            guard let erro = error else{
                self.provas = result
//                self.collectionView.reloadData()
                self.configArrayImg()
                return
            }
            
            self.navigationController?.showAlert(erro.localizedDescription)
            return
        }
    }
    
    func configArrayImg(){
        parseManager.getImgForArrayObject(provas, keyName: "Imagem") { (imagens, error) -> () in
            guard let erro = error else{
                self.arrayImg = imagens
                self.collectionView.reloadData()
                return
            }
            
            self.navigationController?.showAlert(erro.localizedDescription)
            return
        }
    }
    
    func configButtons(){
        let buttonHeight = self.configButtonHeight()
        
        self.inserirQuestaoButton.addConstraint(NSLayoutConstraint(item: self.inserirQuestaoButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight))
        
        self.inserirProvaButton.addConstraint(NSLayoutConstraint(item: self.inserirProvaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight))
        
        self.estudarProvaButton.addConstraint(NSLayoutConstraint(item: self.estudarProvaButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight))
        
//        self.inserirQuestaoButton.layer.borderWidth = 0.5
//        self.inserirProvaButton.layer.borderWidth = 0.5
//        self.estudarProvaButton.layer.borderWidth = 0.5
    }
    
    func configButtonHeight() -> CGFloat{
        let model = self.getDeviceName()
        
        switch model{
        case "iPhone 6":
            return 130
        case "iPhone 6 Plus":
            return 145
        case "iPhone 6S":
            return 120
        case "iPhone 5":
            return 95
        case "iPhone 5S":
            return 90
        case "iPhone 4":
            return 65
        case "iPhone 4S":
            return 65
        default:
            return 60
        }
    }
    
    func getDeviceName() -> String{
        let deviceType: DeviceTypes = UIDevice().deviceType
        let deviceName: String = deviceType.rawValue
        
        return deviceName
    }
    
//    MARK: DisableView
    func disableViewWhileMenuActive(){
        self.view.userInteractionEnabled = false
        self.revealViewController().revealToggle(self)
    }
    
//    MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provas.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mainCell", forIndexPath: indexPath) as! CollectionViewCell
        
        let prova = provas[indexPath.row]
        cell.setNewProva(prova)
        
        let img = arrayImg[indexPath.row]
        cell.setNewImage(img)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let prova = provas[indexPath.row]
        self.loadProva(prova)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
//    MARK: Load Prova
    func getDisciplinas(prova: PFObject, disciplinas: String, error: NSError?){
        self.enableView()
        if(error != nil){
            self.navigationController?.showAlert(error!.localizedDescription)
            return
        }
        
        let storyBoard = UIStoryboard(name: "IPhoneProva", bundle: nil)
        let newView = storyBoard.instantiateInitialViewController() as! ProvaTableViewController
        newView.enableDelete = false
        newView.setNewProva(prova, discs: disciplinas)
        
        self.navigationController?.pushViewController(newView, animated: true)
    }
    
    func loadProva(prova: PFObject){
        self.disabeView()
        
        parseManager.getDisciplinasByProva(prova) { (disciplinas, error) -> () in
            self.getDisciplinas(prova, disciplinas: disciplinas, error: error)
        }
    }
    
    @IBAction func goToRandomProva(sender: AnyObject) {
        self.disabeView()
        
        parseManager.getProvaAleatoria { (prova, error) -> () in
            if(error != nil){
                self.enableView()
                self.navigationController?.showAlert(error!.localizedDescription)
                return
            }
            
            self.parseManager.getDisciplinasByProva(prova!, completionHandler: { (disciplinas, error) -> () in
                self.getDisciplinas(prova!, disciplinas: disciplinas, error: error)
            })
        }
    }
    
//    MARK: Navigation
    
    func goToProva(questoes: [PFObject]){
        let storyboard = UIStoryboard(name: "IPhoneExercicios", bundle: nil)
        
        self.auxQuestoes.questao = questoes[0]
//        print(self.auxQuestoes.questao.valueForKey("Enunciado"))
        self.auxQuestoes.objectId = questoes[0].objectId!
        self.auxQuestoes.indexQuestaoSelecionada = 1
        let newView = storyboard.instantiateViewControllerWithIdentifier("QuestaoSWReveal") as! SWRevealViewController
        
        self.navigationController?.presentViewController(newView, animated: true, completion: nil)
        
        newView.rearViewController.setValue(questoes, forKey: "myArray")
        
        QuestoesManager.singleton.tamanhoDasQuestoes(questoes.count)
    }
}
