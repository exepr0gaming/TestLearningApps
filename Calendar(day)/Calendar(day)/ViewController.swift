//
//  ViewController.swift
//  Calendar(day)
//
//  Created by admin on 08.02.2021.
//

import UIKit

class ViewController: UIViewController {


	@IBOutlet weak var dayTF: UITextField!
	@IBOutlet weak var monthTF: UITextField!
	@IBOutlet weak var yearTF: UITextField!
	
	@IBOutlet weak var setDayLabel: UILabel!
	
	
	@IBAction func buttonSetDay(_ sender: UIButton) {
		setDayLabel.text = myReturnDate()
	}
	func myReturnDate() -> String {
		
		let calendar = Calendar.current
		var dateComponents = DateComponents()
		
		guard let day = dayTF.text, let month = monthTF.text, let year = yearTF.text else { return "" }
		dateComponents.day = Int(day)
		dateComponents.month = Int(month)
		dateComponents.year = Int(year)
		
		guard let date = calendar.date(from: dateComponents) else { return "" }
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_Ru")
		dateFormatter.dateFormat = "EEEE"
		
		let weekDay = dateFormatter.string(from: date)
		
		return weekDay
	
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	

	
	
}

