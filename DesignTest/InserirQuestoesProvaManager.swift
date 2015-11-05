//
//  InserirQuestoesProvaManager.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 04/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirQuestoesProvaManager: NSObject {
    static let singleton = InserirQuestoesProvaManager()
    
    var adicionadas: [PFObject] = []

    func getImg(questao: PFObject, completionHandler:(UIImage?)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var img: UIImage?
            
            guard let newImage = questao.objectForKey("Imagem") as? PFFile else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(img)
                })
                return
            }
            
            guard let newData = newImage.getData() else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(img)
                })
                return
            }
            
            img = UIImage(data: newData)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(img)
            })
            return
        })
    }
}