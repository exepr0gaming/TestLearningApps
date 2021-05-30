//
//  UIView + Exntension.swift
//  ContactsApp(sketch)
//
//  Created by admin on 05.05.2021.
//

import UIKit

extension UIView  {
	
	// маска для обрезания
	func circumcisionMask(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
}
