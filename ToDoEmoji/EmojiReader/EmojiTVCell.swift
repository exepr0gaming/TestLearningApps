//
//  EmojiTVCell.swift
//  EmojiReader
//
//  Created by admin on 07.04.2020.
//  Copyright © 2020 Andrew Kurdin. All rights reserved.
//

import UIKit

class EmojiTVCell: UITableViewCell {
	@IBOutlet var emojiLabel: UILabel!
	@IBOutlet var emojiTitle: UILabel!
	@IBOutlet var emojiDescription: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func set(objectEmoji: EmojiStruct) {
		self.emojiLabel.text = objectEmoji.emoji
		self.emojiTitle.text = objectEmoji.name
		self.emojiDescription.text = objectEmoji.description
	}

}
