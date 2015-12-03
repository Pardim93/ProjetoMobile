//
//  SobreViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 17/11/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var configuration: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configView()
    }
    
//    MARK: Config
    func configView(){
        switch configuration{
        case "VestibulandosLicense":
            self.configVestibulandos()
            return
            
        case "EDStarLicense":
            self.configEDStar()
            return
            
        case "SWRevealLicense":
            self.configSWReveal()
            return
            
        case "ZFRippleLicense":
            self.configZFRipple()
            return
            
        default:
            return
        }
    }
    
    func configVestibulandos(){
        self.title = "Vestibulandos"
        
        self.titleLabel.text = "Vestibulandos"
        
        let textoPrincipal = "O aplicativo Vestibulandos foi criado no Brasil para auxiliar estudantes que buscam por alternativas em sua rotina de preparação para os exames de admissão das instituições de ensino superior. Com ele é possível criar e resolver provas e questões personalizadas."
        
        let membrosDoGrupo = "\n\nAndré Ota\nWellington Pardim"
        
        let icones = "\n\nÍcones por:"
        
        let icones1 = "\n\nhttp://www.flaticon.com"
        
        let icones2 = "\nhttp://www.freepik.com"
        
        let icones3 = "\nhttp://www.flaticon.com/authors/balraj-chana"
        
        let icones4 = "\nhttp://www.icons8.com"
        
        let contato = "\n\n\n\nsuporteVestibulandos@gmail.com"
        
        self.textView.text = textoPrincipal + membrosDoGrupo + icones + icones1 + icones2 + icones3 + icones4 + contato
        
        self.textView.textAlignment = .Center
        self.textView.font = UIFont(name: "Avenir Book", size: 14)
        
//        self.textView.layer.cornerRadius = 10
//        self.textView.layer.borderWidth = 0.3
//        self.textView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func configEDStar(){
        self.title = "EDStarRating"
        
        self.titleLabel.text = "EDStarRating"
        
        self.textView.text = "BSD License. Copyright (c) 2014, Ernesto García All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: \n* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n* Neither the name of the nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
        
        self.textView.textAlignment = .Justified
        self.textView.font = UIFont(name: "Avenir Book", size: 14)
    }
    
    func configSWReveal(){
        self.title = "SWRevealViewController"
        
        self.titleLabel.text = "SWRevealViewController"
        
        self.textView.text = "Copyright (c) 2013 Joan Lluch joan.lluch@sweetwilliamsl.com\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        
        self.textView.textAlignment = .Justified
        self.textView.font = UIFont(name: "Avenir Book", size: 14)
    }
    
    func configZFRipple(){
        self.title = "ZFRippleButton"
        
        self.titleLabel.text = "ZFRippleButton"
        
        self.textView.text = "The MIT License (MIT)\n\nCopyright (c) 2014 Amornchai Kanokpullwad\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to dealin the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        
        self.textView.textAlignment = .Justified
        self.textView.font = UIFont(name: "Avenir Book", size: 14)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
}
