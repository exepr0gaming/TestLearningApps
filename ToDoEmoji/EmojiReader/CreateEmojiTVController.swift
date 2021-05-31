//
//  CreateEmojiTVController.swift
//  EmojiReader
//
//  Created by admin on 07.04.2020.
//  Copyright © 2020 Andrew Kurdin. All rights reserved.
//

import UIKit

class CreateEmojiTVController: UITableViewController {
	@IBOutlet var emojiTF: UITextField!
	@IBOutlet var nameTF: UITextField!
	@IBOutlet var descriptionTF: UITextField!
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var saveButton: UIBarButtonItem!
	
	var emoji = EmojiStruct(emoji: "", name: "", description: "")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateUI()
		saveFuncButton()
	}
	
	@IBAction func saveFuncButton() {
		let emojiText = emojiTF.text ?? ""
		let nameText = nameTF.text ?? ""
		
		saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty
	}
	
	private func updateUI() {
		emojiTF.text = emoji.emoji
		nameTF.text = emoji.name
		descriptionTF.text = emoji.description
	}
	
	@IBAction func textChanged(_ sender: Any) {
		saveFuncButton()
	} // emoji and name - required TF
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		guard segue.identifier == "saveSegue" else { return }
		
		let emoji = emojiTF.text ?? ""
		let name = nameTF.text ?? ""
		let description = descriptionTF.text ?? ""
		
		self.emoji = EmojiStruct(emoji: emoji, name: name, description: description)
	}
}
