//
//  DetailDogViewController.swift
//  PhotoTapps
//
//  Created by admin on 04.03.2021.
//

import UIKit

class DetailDogViewController: UIViewController {

	@IBOutlet weak var imageViewDetailDog: UIImageView!
	var image: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		imageViewDetailDog.image = image
    }
    
	@IBAction func tapToShareButton(_ sender: UIButton) {
		
		let shareController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
		shareController.completionWithItemsHandler = { _, bool, _, _ in
			if bool {
				print("GratZ")
			}
		}
		present(shareController, animated: true, completion: nil)
	}
}
