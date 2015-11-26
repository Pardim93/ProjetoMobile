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
//        self.frame.size = CGSizeMake(160, 160)
        self.layer.cornerRadius = 5
//        self.imgView.layer.cornerRadius = 5
        self.labelText.layer.cornerRadius = 5
        
        self.layer.borderWidth = 0.3
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
