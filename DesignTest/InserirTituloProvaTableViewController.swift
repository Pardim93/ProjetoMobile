//
//  InserirTituloProvaTableViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirTituloProvaTableViewController: UITableViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var adicionarImgBotao: ZFRippleButton!
    @IBOutlet weak var tituloTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavBarHidingCells()
        self.configTableView()
        self.configImagemCell()
    }
    
//    MARK: Config
    func configTableView(){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 30))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
//    MARK: ConfigCells
    func configImagemCell(){
        self.configAddBotao()
        self.configGestureRecognizer()
    }

//    MARK: ConfigImagemCell
    func configImageView(){
        self.imagem.layer.borderColor = UIColor.blackColor().CGColor
        self.imagem.layer.borderWidth = 4.0
    }
    
    func configAddBotao(){
        self.adicionarImgBotao.layer.borderColor = UIColor.clearColor().CGColor
        self.adicionarImgBotao.layer.borderWidth = 0.5
        self.adicionarImgBotao.layer.cornerRadius = 5
    }
    
    func configGestureRecognizer(){
        let gesture = UITapGestureRecognizer(target: self, action: "showActionSheet")
        gesture.delegate = self
        self.imagem.userInteractionEnabled = true
        self.imagem.addGestureRecognizer(gesture)
    }
    
//    MARK: Get
    func getTitulo() -> String{
        return self.tituloTextField.text!
    }
    
    func getCapa() -> UIImage?{
        return self.imagem.image
    }
    
//    MARK: ButtonAction
    @IBAction func adicionarImagemAction(sender: AnyObject) {
        self.showActionSheet()
    }
    
//    MARK: Check
    func checkTitulo() -> Bool{
        guard let text = self.tituloTextField.text else{
            self.tituloTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        if(text.characters.count < 5){
            self.tituloTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        if(!text.hasLetter()){
            self.tituloTextField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        self.tituloTextField.layer.borderColor = UIColor.blackColor().CGColor
        return true
    }
    
    func checkImagem() -> Bool{
        return self.imagem != nil
    }
    
//    MARK: TextField
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(range.length + range.location > textField.text?.characters.count){
            return false
        }
        
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        return (newLength <= 25)
    }
    
//    MARK: ImagePicker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else{
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        imagem.image = selectedImage
//        cell.deleteButton.hidden = false
        self.configImageView()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    MARK: Action Sheet
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Vestibulandos", message: "", preferredStyle: .ActionSheet)
        actionSheet.addAction(self.createCameraAction())
        actionSheet.addAction(self.createGaleryAction())
        actionSheet.addAction(self.createCancelAction())
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createCameraAction() -> UIAlertAction{
        let cameraAction = UIAlertAction(title: "Câmera", style: .Default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.navigationController?.presentViewController(picker, animated: true, completion: nil)
        }
        
        return cameraAction
    }
    
    func createGaleryAction() -> UIAlertAction{
        let galeryAction = UIAlertAction(title: "Fotos", style: .Default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.navigationController?.presentViewController(picker, animated: true, completion: nil)
        }
        
        return galeryAction
    }
    
    func createCancelAction() -> UIAlertAction{
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        return cancelAction
    }
    
//    MARK: TableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }    
}
