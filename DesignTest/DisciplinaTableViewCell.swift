//
//  DisciplinaTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class DisciplinaTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let parseManager = ParseManager.singleton
    @IBOutlet weak var disciplinaPicker: UIPickerView!
    var disciplinas: [PFObject] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        self.disciplinaPicker.delegate = self
        self.disciplinaPicker.dataSource = self
        parseManager.getDisciplinas { (result, error) -> () in
            if(error == nil){
                self.disciplinas = result
                self.disciplinaPicker.reloadAllComponents()
                self.configPickerView()
                return
            }
            else{
                
            }
        }
        return
//        self.configPickerView()
    }
    
//    MARK: Config
    func configPickerView(){
        disciplinaPicker.selectRow(disciplinas.count/2, inComponent: 0, animated: false)
    }
    
//    MARK: Get
    func getDisciplinas(){
        parseManager.getDisciplinas { (result, error) -> () in
            if(error == nil){
                self.disciplinas = result
                self.configPickerView()
                return
            }
            else{
                
            }
        }
        return
    }

//    MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return disciplinas.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let nomeDisc = disciplinas[row].objectForKey("Nome") as! String
        return nomeDisc
    }

//    MARK: CheckConteudo
    func disciplinaValida() -> Bool{
        return true
    }
    
//    MARK: Retorno
    func getDisciplina() -> PFObject{
        let row = self.disciplinaPicker.selectedRowInComponent(0)
        
        return disciplinas[row]
    }
    
    //    MARK: Other
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
