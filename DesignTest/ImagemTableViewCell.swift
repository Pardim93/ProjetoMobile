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
    @IBOutlet weak var addBotao: ZFRippleButton!
    
    var delegate: QuestaoImagemDelegate?
    var imgChange = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.configGestureRecognizer()
        self.configAddBotao()
    }
    
//    MARK: Config
    func configImageView(){
        self.imagem.layer.borderColor = UIColor.blackColor().CGColor
        self.imagem.layer.borderWidth = 4.0
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
    
    func configOldImg(oldImg: UIImage?){
//        guard let _ =
    }
    
//    MARK: Get
    func getImage() -> UIImage?{
        if(!self.imgChange){
            return nil
        }
        
        return self.imagem.image
    }
    
//    MARK: Set
    func setNewImage(newImage: UIImage){
        self.imagem.image = newImage
        self.configImageView()
        self.imgChange = true
    }
    
//    MARK: DeleteImagem
    func deleteImagem(){
        self.imagem.layer.borderWidth = 0
        self.imagem.image = UIImage(named: "picture64")
    }
    
//    MARK: Validação
    func imagemValida() -> Bool{
        return self.imagem.image != nil
    }
    
//        MARK: Gesture Handler
    func tapHandle(){
        self.delegate?.showActionSheet()
    }
    
//        MARK: Button
    @IBAction func pickPhoto(sender: AnyObject) {
        self.delegate?.showActionSheet()
    }
}
