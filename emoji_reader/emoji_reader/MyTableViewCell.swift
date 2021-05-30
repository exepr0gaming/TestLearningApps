//
//  MyTableViewCell.swift
//  emoji_reader
//
//  Created by admin on 22.02.2021.
//

import UIKit

class MyTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var emojiViewLabel: UILabel!
	@IBOutlet weak var emojiNameLabel: UILabel!
	@IBOutlet weak var emojiDescriptionLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func set(emoj: EmojiList) {
		self.emojiViewLabel.text = emoj.view
		self.emojiNameLabel.text = emoj.name
		self.emojiDescriptionLabel.text = emoj.description
	}

}
