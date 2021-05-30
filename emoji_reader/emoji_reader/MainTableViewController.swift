//
//  MainTableViewController.swift
//  emoji_reader
//
//  Created by admin on 22.02.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
	
	var emojis = [
		EmojiList(view: "😊", name: "Lucky", description: "Lucky retard", liked: false),
		EmojiList(view: "😇", name: "Angel", description: "Angel boosted", liked: false),
		EmojiList(view: "😍", name: "Love", description: "Love you tard", liked: false),
		EmojiList(view: "😎", name: "Boss", description: "Like a boss", liked: true
	)]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		self.navigationItem.leftBarButtonItem = self.editButtonItem
		self.title = "Hello boys, it's Emojis Reader!"
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return emojis.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! MyTableViewCell
		let emoj = emojis[indexPath.row]
		cell.set(emoj: emoj)
		
		return cell
	}
	
	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
	
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//		if indexPath.row % 2 == 0 {
//			return .delete
//		} else {
//			return .insert
//		}
		return .delete // default method
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			emojis.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			print("321")
		}
	}
	
	
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let emojiMoved = emojis.remove(at: sourceIndexPath.row)
		emojis.insert(emojiMoved, at: destinationIndexPath.row)
		tableView.reloadData()
	
	}
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let done = doneAction(at: indexPath)
		let favourite = favouriteAction(at: indexPath)
		
		return UISwipeActionsConfiguration(actions: [done, favourite])
	}
	
	func doneAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			self.emojis.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			completion(true) // чтобы на этом все завершилось
		}
		action.backgroundColor = .systemRed
		action.image = UIImage(systemName: "delete.right")
		return action
	}
	
	func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
		var emoji = emojis[indexPath.row]
		let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completion) in
			emoji.liked = !emoji.liked
			self.emojis[indexPath.row] = emoji
			completion(true)
		}
		action.backgroundColor = emoji.liked ? .systemPurple : .systemGray
		action.image = UIImage(systemName: "heart")
		return action
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
	@IBAction func unwindSegue(segue: UIStoryboardSegue) {
		guard segue.identifier == "saveSegue" else { return }
		let sourceTVC = segue.source as! AddEmojiTableViewController
		let emoji = sourceTVC.newEmoji
		
		
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			emojis[selectedIndexPath.row] = emoji
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
		} else {
			let newIndexPath = IndexPath(row: emojis.count, section: 0)
			emojis.append(emoji)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		guard segue.identifier == "editSegue" else { return }
		let indexPath = tableView.indexPathForSelectedRow!
		let emoji = emojis[indexPath.row]
		
		let navVC = segue.destination as! UINavigationController
		let destVC = navVC.topViewController as! AddEmojiTableViewController
		
		destVC.newEmoji = emoji
		destVC.title = "Edit Emoji"
		
	}
	
}
