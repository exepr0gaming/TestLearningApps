//
//  ViewController.swift
//  TimeToEat
//
//  Created by admin on 28.04.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	var context: NSManagedObjectContext!
	var user: User!
	
	@IBOutlet weak var tableView: UITableView!
	
	lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		let userName = "Andrew"
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		// предикат, чтобы получить данные конкретного юзера
		fetchRequest.predicate = NSPredicate(format: "name == %@", userName)
		
		do {
			let results = try context.fetch(fetchRequest)
			if results.isEmpty {
				// если юзер по имени не найден, создаём нового и присваиваем имя
				user = User(context: context)
				user.name = userName as NSObject
				try context.save()
			} else {
				user = results.first
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	@IBAction func addButtonPressed(_ sender: AnyObject) {
		let meal = Meal(context: context)
		meal.date = Date()
		let meals = user.meals?.mutableCopy() as? NSMutableOrderedSet
		meals?.add(meal)
		user.meals = meals
		
		do {
			try context.save()
			tableView.reloadData()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
	}
	
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "My happy meal time"
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return user.meals?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
		
		guard let meal = user.meals?[indexPath.row] as? Meal,
					let mealDate = meal.date
		else { return cell }
		
		cell.textLabel!.text = dateFormatter.string(from: mealDate)
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard let meal = user.meals?[indexPath.row] as? Meal, editingStyle == .delete else { return }
		// так как meal лежит в контексе, то сначала удаляем его оттуда
		context.delete(meal)
		do {
			try context.save()
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
}

