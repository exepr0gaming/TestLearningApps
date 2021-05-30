//
//  UIFont + Exntension.swift
//  ContactsApp(sketch)
//
//  Created by admin on 05.05.2021.
//

import UIKit

extension UIFont {
	
	enum RoundedWeight {
		case regular, medium, semibold
	}
	
	static func sfProRounded(ofSize size: CGFloat, weight: RoundedWeight) -> UIFont? {
		
		switch weight {
			
			case .regular:
				return UIFont.init(name: "SFProRounded-Regular", size: size)
			case .medium:
				return UIFont.init(name: "SFProRounded-Medium", size: size)
			case .semibold:
				return UIFont.init(name: "SFProRounded-Semibold", size: size)
		}
		
	}
	
}
