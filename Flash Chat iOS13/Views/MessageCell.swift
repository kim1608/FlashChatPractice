//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    weak var viewController: ChatViewController?
    private var message: Message?
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageBubble.layer.cornerRadius = 6
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:)))
        self.contentView.addGestureRecognizer(gestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(with message: Message) {
        self.message = message
        self.label.text = message.body
    }
    
    @objc func cellLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard let message = message,
            sender.state == .began else {
            return
        }
        
        let alert = UIAlertController(title: "Warning", message: "Delete this message", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            self.viewController?.deleteMessage(message: message)
        }
        alert.addAction(okAction)
        let cancleAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(cancleAction)
        self.viewController?.present(alert, animated: true, completion: nil)
    }
}
