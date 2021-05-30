//
//  PhotosCollectionViewController.swift
//  PhotoTapps
//
//  Created by admin on 28.02.2021.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {

	let defaultPadding: CGFloat = 4
	let defPadInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	
	let photos = ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6", "dog7", "dog8", "dog9", "dog10", "dog11", "dog12", "dog13", "dog14", "dog15"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

//			let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//			layout.itemSize = CGSize(width: 50, height: 50)
//			layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//			layout.minimumInteritemSpacing = 1
//			layout.minimumLineSpacing = 1
			
    }

    
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "dogDetailSegue"  {
			let detailPhotoVC = segue.destination as! DetailDogViewController
			let cell = sender as? PhotoCollectionViewCell
			detailPhotoVC.image = cell?.dogImageView.image
		}
	}

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
			let image = UIImage(named: photos[indexPath.item])
			cell.dogImageView.image = image
    
        return cell
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow: CGFloat = 3
		let paddingWidth = defaultPadding * (itemsPerRow + 1)
		let availableWidth = collectionView.frame.width - paddingWidth
		let widthItem = availableWidth / itemsPerRow
		return CGSize(width: widthItem, height: widthItem)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return defPadInset
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return defPadInset.right // example
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return defaultPadding
	}
}
