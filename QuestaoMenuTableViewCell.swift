import UIKit

class QuestaoMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgMarker: UIImageView!
    @IBOutlet weak var labelQuestao: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}