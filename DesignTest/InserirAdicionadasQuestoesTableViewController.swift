//
//  InserirAdicionadasQuestoesTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 28/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirAdicionadasQuestoesTableViewController: UITableViewController, CustomTextViewDelegate {
    
    var questoes: [PFObject] = []
    let inserirQuestoesManager = InserirQuestoesProvaManager.singleton
    var longTapGesture: UILongPressGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configSegmentedHidingCells()
        self.configGestureRecognizer()
        self.configToolbar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configTableView()
        self.updateQuestoes()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configActivityView()
    }
    
//    MARK: Config
    func configTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "InserirQuestaoTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
        
        self.tableView.addGestureRecognizer(longTapGesture!)
        
        self.view.backgroundColor = UIColor(red: 0.937254905700684, green: 0.937254905700684, blue: 0.95686274766922, alpha: 1)
    }

    func configSegmentedHidingCells(){
        let header = UIView(frame: CGRectMake(0, 0, 1, 42))
        header.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = header
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 50))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
    func configGestureRecognizer(){
        self.longTapGesture = UILongPressGestureRecognizer(target: self, action: "changeEditing")
    }
    
    func configToolbar(){
        let finishButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "finishEditing")
        
        self.navigationController?.toolbar.setItems([finishButton], animated: false)
    }
    
//    MARK: Get
    func getQuestoes() -> [PFObject]{
        return self.questoes
    }
    
//    MARK: Selectors
    func changeEditing(){
        self.tableView.removeGestureRecognizer(longTapGesture!)
        self.setEditing(true, animated: true)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let finishButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "finishEditing")
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, finishButton], animated: false)
    }
    
    func finishEditing(){
        self.tableView.addGestureRecognizer(longTapGesture!)
        self.tableView.setEditing(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func finishEdit(cellRow: Int) {
        self.view.endEditing(true)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 1), animated: false)
        
        let newQuestao = questoes[cellRow]
        
        self.prepareGoToQuestao(newQuestao)
    }
    
//    MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questoes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! InserirQuestaoTableViewCell
        
        let newQuestao = questoes[indexPath.row]
        
        cell.descricaoTextView.customDelegate = self
        cell.setInfo(newQuestao, newRow: indexPath.row)
        
        cell.setButtonStatus(false)
        cell.adicionarButton.enabled = false
        cell.adicionarButton.hidden = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let newQuestao = questoes[indexPath.row]
        
        self.prepareGoToQuestao(newQuestao)
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = questoes[sourceIndexPath.row]
        questoes.removeAtIndex(sourceIndexPath.row)
        questoes.insert(itemToMove, atIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.questoes.removeAtIndex(indexPath.row)
        self.inserirQuestoesManager.adicionadas.removeAtIndex(indexPath.row)
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
//    MARK: Check
    func checkQuestoes() -> Bool{
        return (self.questoes.count >= 5 && self.questoes.count <= 90)
    }
    
//    MARK: Update
    func updateQuestoes(){
        self.questoes = inserirQuestoesManager.adicionadas
        self.tableView.reloadData()
    }
    
//    MARK: Navigation
    func prepareGoToQuestao(questao: PFObject){
        self.disabeView()
        
        self.inserirQuestoesManager.getImg(questao){(newImg) -> () in
            self.enableView()
            self.goToQuestao(questao, img: newImg)
        }
    }
    
    func goToQuestao(questao: PFObject, img: UIImage?){
        
        let newTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("verExTabBar") as! VerQuestaoTabBarViewController
        newTabBar.questao = questao
        newTabBar.img = img
        
        self.navigationController?.pushViewController(newTabBar, animated: true)
    }
}
