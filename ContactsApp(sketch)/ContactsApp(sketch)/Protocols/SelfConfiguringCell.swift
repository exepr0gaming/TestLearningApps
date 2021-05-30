//
//  SelfConfiguringCell.swift
//  ContactsApp(sketch)
//
//  Created by admin on 04.05.2021.
//

import UIKit

protocol SelfConfiguringCell {
	static var reuseId: String { get }
	func configure(with user: ContactsModel.User)
}
