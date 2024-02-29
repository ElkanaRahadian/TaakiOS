import UIKit

class BadgesTableViewCell: UITableViewCell {

    @IBOutlet weak var badgesImage: UIImageView!
    @IBOutlet weak var badgesTitleLabel: UILabel!
    @IBOutlet weak var badgesDetailLabel: UILabel!
    @IBOutlet weak var badgesProgressView: UIProgressView!
    @IBOutlet weak var badgesProgressDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
