//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Leon Wong on 19/9/2020.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() { //Nib is an old name of xib
        super.awakeFromNib()
        // Initialization code
        //This is going to be called when we create a new message cell from the MessageCell.xib.
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
