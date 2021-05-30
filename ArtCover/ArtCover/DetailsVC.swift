//
//  DetailsVC.swift
//  ArtCover
//
//  Created by admin on 18.03.2021.
//

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
