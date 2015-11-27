//
//  InserirEnunciadoTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 02/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirEnunciadoTableViewController: UITableViewController, QuestaoImagemDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let arrayCell = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTabbarHidingCells()
        self.configNavBarHidingCells()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

//    MARK: Config
    override func viewDidAppear(animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //    MARK: Config
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 30))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 1))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
//    MARK: CheckConteudo
    func enunciadoValido() -> Bool{
        if !(self.arrayCell.count > 0){
            return false
        }
        
        guard let cell = self.arrayCell.objectAtIndex(0) as? EnunciadoTableViewCell else{
            return false
        }
        
        return cell.enunciadoValido()
    }
    
    func imagemValida() -> Bool{
        if !(self.arrayCell.count > 0){
            return false
        }
        
        guard let cell = self.arrayCell.objectAtIndex(1) as? ImagemTableViewCell else{
            return false
        }
        
        return cell.imagemValida()
    }

//    MARK: TableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if (row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("enunciadoCell", forIndexPath: indexPath) as! EnunciadoTableViewCell
            arrayCell.addObject(cell)
            return cell
        } else{
            let cell = tableView.dequeueReusableCellWithIdentifier("imagemCell", forIndexPath: indexPath) as! ImagemTableViewCell
            cell.delegate = self
            arrayCell.addObject(cell)
            return cell
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        if (row == 0){
            return 220
        }
        
        return 350
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
//    MARK: ImagemDelegate
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Vestibulandos", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(self.getCameraAction())
        actionSheet.addAction(self.getGaleryAction())
        actionSheet.addAction(self.getCancelAction())
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
//    MARK: ImagePicker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else{
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        guard let cell = self.arrayCell.objectAtIndex(1) as? ImagemTableViewCell else{
            return
        }
        
        cell.setNewImage(selectedImage)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCameraAction() -> UIAlertAction{
        let cameraAction = UIAlertAction(title: "Câmera", style: .Default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.navigationController?.presentViewController(picker, animated: true, completion: nil)
        }
        
        return cameraAction
    }
    
    func getGaleryAction() -> UIAlertAction{
        let galeryAction = UIAlertAction(title: "Fotos", style: .Default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.navigationController?.presentViewController(picker, animated: true, completion: nil)
        }
        
        return galeryAction
    }
    
    func getCancelAction() -> UIAlertAction{
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        return cancelAction
    }
    
//    MARK: DeleteImagem
    func showDeleteAlert() {
        let deleteAlert = UIAlertController(title: "Vestibulandos", message: "Deseja mesmo deletar essa imagem?", preferredStyle: .Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Sim", style: .Default) { (action) in
            guard let cell = self.arrayCell.objectAtIndex(1) as? ImagemTableViewCell else{
                return
            }
            
            cell.deleteImagem()
            })
        
        deleteAlert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        self.navigationController?.presentViewController(deleteAlert, animated: true, completion: nil)
    }
}
