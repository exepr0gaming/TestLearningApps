import UIKit

class DetailsVC: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	var trackTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

			imageView.image = UIImage(named: trackTitle)
			titleLabel.text = trackTitle
			titleLabel.numberOfLines = 0
    }
    
}
