//
//  CollectionViewCell.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 9/10/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    var prova: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configCell()
    }
    
//    MARK: Config
    func configCell(){
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.5
        
        self.labelText.layer.cornerRadius = 5
        
//        self.backgroundColor = UIColor.colorWithHexString("#BBBEBF", alph: 0.3)
//        self.backgroundColor = UIColor.colorWithHexString("#FFBB00", alph: 1.0)
    }
    
//    MARK: Set
    func setNewProva(newProva: PFObject){
        self.prova = newProva
        
        self.labelText.text = prova.objectForKey("Titulo") as? String
    }
    
    func setNewImage(imagem: UIImage?){
        guard let img = imagem else{
            self.imgView.image = UIImage(named: "image6")
            return
        }
        
        self.imgView.image = img
    }
}
