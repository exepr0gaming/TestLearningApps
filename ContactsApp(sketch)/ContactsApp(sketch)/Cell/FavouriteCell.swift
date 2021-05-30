//
//  FavouriteCell.swift
//  ContactsApp(sketch)
//
//  Created by admin on 04.05.2021.
//

import UIKit

class FavouriteCell: UICollectionViewCell, SelfConfiguringCell {

	static var reuseId = "FavouriteCell"
	
	let imageView = UIImageView()
	let nameLabel = UILabel()
	let phoneImageView = UIImageView()
	let videoImageView = UIImageView()
	let mailImageView = UIImageView()
	
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .systemGroupedBackground
	}
	
	func configure(with user: ContactsModel.User) {
		nameLabel.text = user.fullname
		nameLabel.font = UIFont.sfProRounded(ofSize: 14, weight: .medium)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.image = UIImage(named: user.imageString)
		imageView.layer.cornerRadius = 20
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		phoneImageView.image = #imageLiteral(resourceName: "circle phone")
		videoImageView.image = #imageLiteral(resourceName: "circle video")
		mailImageView.image = #imageLiteral(resourceName: "circle mail")

		let stackView = UIStackView(arrangedSubviews: [phoneImageView, videoImageView, mailImageView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.spacing = 5
		stackView.distribution = .fillEqually
		
		addSubview(imageView)
		addSubview(nameLabel)
		addSubview(stackView)
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			imageView.heightAnchor.constraint(equalToConstant: 40),
			imageView.widthAnchor.constraint(equalToConstant: 40)
		])
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
		])
		
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7)
		])
		
	}
	
	override func layoutSubviews() {
		self.layer.cornerRadius = 15
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	
	
}