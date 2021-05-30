//
//  SectionHeader.swift
//  ContactsApp(sketch)
//
//  Created by admin on 05.05.2021.
//

import UIKit

class SectionHeader: UICollectionReusableView {
	
	static let reuseId = "SectionHeader"
	let titleLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .systemGroupedBackground
		titleLabel.font = UIFont.sfProRounded(ofSize: 18, weight: .semibold)
		titleLabel.textColor = #colorLiteral(red: 0.5294117647, green: 0.5450980392, blue: 0.5843137255, alpha: 1)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	override func layoutSubviews() {
		self.layer.cornerRadius = frame.height / 2
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
