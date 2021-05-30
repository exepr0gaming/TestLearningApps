//
//  AddEmojiTableViewController.swift
//  emoji_reader
//
//  Created by admin on 26.02.2021.
//

import UIKit

class AddEmojiTableViewController: UITableViewController {
	
	var newEmoji = EmojiList(view: "", name: "", description: "", liked: false)
	
	@IBOutlet weak var emojiTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateUI()
		updateSaveButtonState()
	}
	
	@IBAction func textEditing(_ sender: UITextField) {
		updateSaveButtonState()
	}
	
	
	
	private func updateSaveButtonState() {
		let emojiText = emojiTextField.text ?? ""
		let nameText = nameTextField.text ?? ""
		let descriptionText = descriptionTextField.text?.count ?? 0
		
		saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && descriptionText > 2
	}
	private func updateUI() {
		emojiTextField.text = newEmoji.view
		nameTextField.text = newEmoji.name
		descriptionTextField.text = newEmoji.description
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		
		return 3
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "saveSegue" else { return }
		
		let emoji = emojiTextField.text ?? ""
		let name = nameTextField.text ?? ""
		let description = descriptionTextField.text ?? ""
		
		self.newEmoji = EmojiList(view: emoji, name: name, description: description, liked: self.newEmoji.liked)
	}
	
	
}
