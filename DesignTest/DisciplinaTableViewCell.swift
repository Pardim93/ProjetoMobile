//
//  DisciplinaTableViewCell.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 25/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class DisciplinaTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var disciplinaPicker: UIPickerView!
    let disciplinas = ["Matemática", "Inglês", "Geografia", "História", "Português", "Biologia", "Física"]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.disciplinaPicker.delegate = self
        self.disciplinaPicker.dataSource = self
        self.configPickerView()
    }
    
//    MARK: Config
    func configPickerView(){
        disciplinaPicker.selectRow(disciplinas.count/2, inComponent: 0, animated: false)
    }

//    MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return disciplinas.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return disciplinas[row]
    }

//    MARK: CheckConteudo
    func disciplinaValida() -> Bool{
        return true
    }
    
//    MARK: Retorno
    func getDisciplina() -> String{
        let row = self.disciplinaPicker.selectedRowInComponent(0)
        
        return disciplinas[row]
    }
    
    //    MARK: Other
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
