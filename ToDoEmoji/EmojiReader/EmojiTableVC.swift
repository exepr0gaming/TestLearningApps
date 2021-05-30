//
//  EmojiTableVC.swift
//  EmojiReader
//
//  Created by admin on 07.04.2020.
//  Copyright © 2020 Andrew Kurdin. All rights reserved.
//

import UIKit

class EmojiTableVC: UITableViewController {
	@IBOutlet var editLeftButton: UIBarButtonItem!
	
	
	var objectsEmoji = [
		EmojiStruct(emoji: "😻", name: "cat love you", description: "it's beautifull"),
		EmojiStruct(emoji: "🙀", name: "cat amazing", description: "woooow"),
		EmojiStruct(emoji: "💋", name: "kiss you", description: "i needed kisses"),
		EmojiStruct(emoji: "👀", name: "Whaaaat", description: "i see you"), ]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.leftBarButtonItem = self.editButtonItem
		
//		navigationItem.leftBarButtonItem =	UIBarButtonItem(barButtonSystemItem: .edit, target: self,
//										action: #selector(editButton))
		
		//self.title = "Emoji Reader"
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	@IBAction func unwindSegue(segue: UIStoryboardSegue) {
		guard segue.identifier == "saveSegue" else { return }
		// добавляем emoji в уже существующий массив
		let sorceVC = segue.source as! CreateEmojiTVController
		let emoji = sorceVC.emoji
		
		// объект будет добавлен как новый только с кнопки +, но если была выбрана ячейка то просто - редактируем
		if let selectedIndexPath = tableView.indexPathForSelectedRow { // если ячейка существует и была выбрана
			objectsEmoji[selectedIndexPath.row] = emoji
			tableView.reloadRows(at: [selectedIndexPath], with: .fade)
		} else { // если ячейка не существует - добавляем новую
			let newIndexPath = IndexPath(row: objectsEmoji.count, section: 0)
			objectsEmoji.append(emoji)
			tableView.insertRows(at: [newIndexPath], with: .fade)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		guard segue.identifier == "editEmoji" else { return }
		let idP = tableView.indexPathForSelectedRow! // indexPath по выбранной ячейке
		let emoji = objectsEmoji[idP.row]
		let navigationVC = segue.destination as! UINavigationController // destination на кот. хотим переместится
		let createEmojiVC = navigationVC.topViewController as! CreateEmojiTVController //topViewController самый верхний контроллер который содержит
		createEmojiVC.emoji = emoji // для отображения всех хар-к выбранного объекта
		createEmojiVC.title = "edit" // изм тайтл второго экрана
	}
	
	
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objectsEmoji.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTVCell
		let objectEmoji = objectsEmoji[indexPath.row]
		cell.set(objectEmoji: objectEmoji) // при переносе логики в TableViewCell
//		cell.emojiLabel.text = objectEmoji.emoji
//		cell.emojiTitle.text = objectEmoji.name
//		cell.emojiDescription.text = objectEmoji.description
		
		return cell
	}
	
	
//	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//	return true
//	}
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete // default value
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			objectsEmoji.remove(at: indexPath.row) // сначала нужно удалить из массива, потом по дефолту с tableView
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
//		else if editingStyle == .insert {
//		}
	}
	
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let movedEmoji = objectsEmoji.remove(at: sourceIndexPath.row)
		objectsEmoji.insert(movedEmoji, at: destinationIndexPath.row)
		tableView.reloadData()
	}
	
	// leadingSwipeActionsConfigurationForRowAt - для вызова слева, trailingSwipeActionsConfigurationForRowAt -справа
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = doneAction(at: indexPath)
		let favourite = favouriteAction(at: indexPath)
		
		return UISwipeActionsConfiguration(actions: [delete, favourite])
	}
	
	func doneAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
			self.objectsEmoji.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic) // automatic - animation
			completion(true) // действие завершится и ничего более происходить не будет
		} //destructive - будет пропадать с экрана
		action.backgroundColor = .systemPurple
		action.image = UIImage(systemName: "delete.right.fill")
		
		return action
	}
	
	func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
		var object = self.objectsEmoji[indexPath.row]
		let action = UIContextualAction(style: .normal, title: "Like") { (action, view, completion) in
			object.like = !object.like
			self.objectsEmoji[indexPath.row] = object
			//print("damn, \(object.like)")
			completion(true)
		}
		action.image = UIImage(systemName: "heart")
		action.backgroundColor = object.like ? .systemGreen : .systemGray3
		
		return action
	}
	
//	@IBAction func editButton(_ sender: UIBarButtonItem) {
//		print("hello boy")
//	}
	
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
