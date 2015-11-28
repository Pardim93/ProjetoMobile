//
//  MainViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    
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
//        self.configArrayImg()
        self.configProvas()
        self.configButtons()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.userInteractionEnabled = true
        
//        self.configButtons()
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
    
//    
//    func configArrayImg(){
//        for index in 0...4{
//            let newImg = UIImage(named: "prova\(index)")
//            arrayImg.append(newImg!)
//        }
//    }
    
    func configButtons(){
        self.inserirQuestaoButton.layer.cornerRadius = 5
        self.inserirProvaButton.layer.cornerRadius = 5
        
        self.estudarProvaButton.layer.cornerRadius = 5
        self.estudarProvaButton.layer.borderColor = UIColor.newBlueColor().CGColor
        self.estudarProvaButton.layer.borderWidth = 0.3
//        
//        let buttonHeight = self.configButtonHeight()
//        
//        self.estudarProvaButton.frame.size = CGSizeMake(self.estudarProvaButton.frame.width, buttonHeight)
//        self.inserirQuestaoButton.frame.size = CGSizeMake(self.inserirQuestaoButton.frame.width, buttonHeight)
//        self.inserirProvaButton.frame.size = CGSizeMake(self.inserirProvaButton.frame.width, buttonHeight)
    }
    
//    func configButtonHeight() -> CGFloat{
//        let model = self.getDeviceName()
//        
//        switch model{
//        case "iPhone 6":
//            return 60
//        case "iPhone 6S":
//            return 60
//        case "iPhone 5":
//            return 40
//        case "iPhone 5S":
//            return 40
//        case "iPhone 4":
//            return 20
//        case "iPhone 4S":
//            return 20
//        default:
//            return 60
//        }
//    }
    
    func loadQuestoesFromProva(prova: PFObject){
        self.disabeView()
        
        parseManager.getQuestoesByProva(prova) { (result, error) -> () in
            self.enableView()
            guard let erro = error else{
                print(result.count)
                self.goToProva(result)
                
                return
            }
            
            self.navigationController?.showAlert(erro.localizedDescription)
            return
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
        self.loadQuestoesFromProva(prova)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
//    MARK: Navigation
    func goToProva(questoes: [PFObject]){
//        
//        self.auxQuestoes.questao = questoes[0]
//        let questaoTemp = questoes[0]
//        self.auxQuestoes.objectId = questaoTemp.objectId!
//        self.auxQuestoes.indexQuestaoSelecionada = 1
//        questoesManager.questaoSelecionada = questoes[0]
//        
//        print(self.auxQuestoes.questao.valueForKey("Enunciado"))
//        let newMenuView = newView.rearViewController as! QuestaoMenuControllerTableViewController
//        
//        newMenuView.myArray = questoes
//        questoesManager.tamanhoDasQuestoes(questoes.count)

        let storyboard = UIStoryboard(name: "IPhoneExercicios", bundle: nil)
        
        
        self.auxQuestoes.questao = questoes[0]
        print(self.auxQuestoes.questao.valueForKey("Enunciado"))
        self.auxQuestoes.objectId = questoes[0].objectId!
        self.auxQuestoes.indexQuestaoSelecionada = 1
        let newView = storyboard.instantiateViewControllerWithIdentifier("QuestaoSWReveal") as! SWRevealViewController
        
        self.navigationController?.presentViewController(newView, animated: true, completion: nil)
        
      
        
   newView.rearViewController.setValue(questoes, forKey: "myArray")
    
        QuestoesManager.singleton.tamanhoDasQuestoes(questoes.count)
        
        
        
        
    }
}
