//
//  ImagemTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 02/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

protocol QuestaoImagemDelegate{
    func showActionSheet()
    func showDeleteAlert()
}

class ImagemTableViewCell: UITableViewCell{

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addBotao: ZFRippleButton!
    
    var delegate: QuestaoImagemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.configGestureRecognizer()
        self.deleteButton.hidden = true
        
        self.configDeleteButton()
        self.configAddBotao()
    }
    
//    MARK: Config
    func configImageView(){
        self.imagem.layer.borderColor = UIColor.blackColor().CGColor
        self.imagem.layer.borderWidth = 4.0
    }
    
    func configDeleteButton(){
        self.deleteButton.layer.cornerRadius = deleteButton.bounds.size.height / 2
//        self.deleteButton.backgroundColor = UIColor.lightGrayColor()
        self.deleteButton.layer.borderColor = UIColor.newBlueColor().CGColor
        self.deleteButton.layer.borderWidth = 2
    }
    
    func configAddBotao(){
        self.addBotao.layer.borderColor = UIColor.clearColor().CGColor
        self.addBotao.layer.borderWidth = 0.5
        self.addBotao.layer.cornerRadius = 5
    }
    
    func configGestureRecognizer(){
        let gesture = UITapGestureRecognizer(target: self, action: "tapHandle")
        gesture.delegate = self
        self.imagem.userInteractionEnabled = true
        self.imagem.addGestureRecognizer(gesture)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
    
//    MARK: DeleteImagem
    func deleteImagem(){
        self.imagem.layer.borderWidth = 0
        self.imagem.image = UIImage(named: "picture64")
        self.deleteButton.hidden = true
    }
    
    //    MARK: Validação
    func imagemValida() -> Bool{
        guard let _ = self.imagem.image else{
            return false
        }
        
        return true
    }
    
//        MARK: Gesture Handler
    func tapHandle(){
        self.delegate?.showActionSheet()
    }
    
//        MARK: Button
    @IBAction func pickPhoto(sender: AnyObject) {
        self.delegate?.showActionSheet()
    }
    
    @IBAction func deleteImage(sender: AnyObject) {
        self.delegate?.showDeleteAlert()
    }
}
