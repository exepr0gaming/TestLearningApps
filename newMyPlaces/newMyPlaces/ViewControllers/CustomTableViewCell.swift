//
//  CustomTableViewCell.swift
//  newMyPlaces
//
//  Created by admin on 25.03.2021.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

	@IBOutlet weak var imageOfPlace: UIImageView! {
		didSet {
			imageOfPlace?.layer.cornerRadius = imageOfPlace.frame.height / 2
			imageOfPlace?.clipsToBounds = true
		}
	}
	@IBOutlet weak var nameOfPlaceLabel: UILabel!
	@IBOutlet weak var locationOfPlaceLabel: UILabel!
	@IBOutlet weak var typeOfPlaceLabel: UILabel!
	@IBOutlet weak var cosmosView: CosmosView! {
		didSet {
			cosmosView.settings.updateOnTouch = false // чтобы не реагировал на клик с главной
			cosmosView.settings.fillMode = .half
		}
	}
	
	
}
