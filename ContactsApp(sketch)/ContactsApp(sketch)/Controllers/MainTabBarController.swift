//
//  MainTabBarController.swift
//  ContactsApp(sketch)
//
//  Created by admin on 03.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadVCs()
	}
	
	private func loadVCs() {
		let contactsVC = ContactsViewController()
		let recentVC = RecenetViewController()
		
		guard	let contactsImage = UIImage(systemName: "person.crop.circle"),
					let recentImage = UIImage(systemName: "clock.fill")	else { return }
		
		viewControllers = [
			generateNavigationController(rootViewController: contactsVC, title: "Contacts", image: contactsImage),
			generateNavigationController(rootViewController: recentVC, title: "Recent", image: recentImage)
		]
	}
	
	// MARK: - Настройка Tab Bar
	private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
		let navigationVC = UINavigationController(rootViewController: rootViewController)
		navigationVC.tabBarItem.title = title
		navigationVC.tabBarItem.image = image
		return navigationVC
	}
	
	
}


