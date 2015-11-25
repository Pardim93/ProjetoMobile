//
//  SobreViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 17/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTextView()
    }
    
    func configTextView(){
        self.textView.text = "O aplicativo Vestibulandos foi criado no Brasil para auxiliar estudantes que buscam por alternativas em sua rotina de preparação para os exames de admissão das instituições de ensino superior. Com ele é possível criar e resolver provas e questões personalizadas.\n\nAndré Ota\nWellington Pardim"
        
//        self.textView.font = UIFont(name: "Avenir Book", size: 16)
//        self.textView.layer.cornerRadius = 10
//        self.textView.layer.borderWidth = 0.3
//        self.textView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
}
