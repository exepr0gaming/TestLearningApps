//
//  ContactCell.swift
//  ContactsApp(sketch)
//
//  Created by admin on 04.05.2021.
//

import UIKit

class ContactCell: UICollectionViewCell, SelfConfiguringCell {
	
	static var reuseId = "ContactCell"
	var user: ContactsModel.User?
	
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
		self.user = user
		
		nameLabel.text = user.fullname
		nameLabel.font = UIFont.sfProRounded(ofSize: 18, weight: .medium)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.image = UIImage(named: user.imageString)
		imageView.layer.cornerRadius = 12.5
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
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 25),
			imageView.widthAnchor.constraint(equalToConstant: 25)
		])
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
			nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		NSLayoutConstraint.activate([
			stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
			stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		
	}
	
	override func layoutSubviews() {
		switch user?.direction {
			
			case .top:
				circumcisionMask(corners: [.topLeft, .topRight], radius: 12)
			case .all:
				circumcisionMask(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12)
			case .bottom:
				circumcisionMask(corners: [.bottomLeft, .bottomRight], radius: 12)
			default: break
		}
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
