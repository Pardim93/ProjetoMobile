//
//  QuestaoTableViewCell.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 10/27/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class QuestaoTableViewCell: UITableViewCell {

    @IBOutlet weak var wideTxt: CustomTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
