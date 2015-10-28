//
//  PerguntasTableViewCell.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 9/22/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//


class PerguntasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textViewResposta: UITextView!
    @IBOutlet weak var labelLetra: UILabel!
    @IBOutlet weak var labelResposta: UILabel!
    var index = 0
    
    @IBOutlet weak var imgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if labelLetra != nil{
            
            self.drawBorders()
            self.frame.size.height = 160
            self.contentView.layer.borderColor = UIColor.blackColor().CGColor
            self.contentView.layer.borderWidth = 20.0
            

            self.textViewResposta.editable = false
            self.textViewResposta.font = UIFont (name: "Avenir book", size: 15)
            self.selectionStyle = .Default
            self.labelLetra.font = UIFont (name: "Avenir book", size: 18)
            self.labelResposta.font = UIFont (name: "Avenir book", size: 18)
            
        }
    }
    
    func drawBorders(){
        let border = CALayer()
        
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 10, y:10, width:  90, height: 90)
        
        border.borderWidth = width
        self.contentView.layer.addSublayer(border)
        self.contentView.layer.masksToBounds = true
        
        
        self.contentView.layer.borderColor = UIColor.redColor().CGColor
        self.contentView.layer.borderWidth = 5
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        
    }
    
    func configImage(){
        
        self.imageView?.bounds.origin.x = 30
        self.imageView?.bounds.origin.y = 10
        self.imgCell.bounds.size = CGSize(width: 20, height:2)
    }
    
    func expandCellHeight(){
        
        self.textViewResposta.hidden = false
        let screenRect = UIScreen.mainScreen().bounds

        self.frame.size.height = screenRect.height
    }
    
    func defaultSize(){
        
        self.frame.size.height = 160
        self.textViewResposta.hidden = true
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //        super.setSelected(selected, animated: animated)
    }
}

