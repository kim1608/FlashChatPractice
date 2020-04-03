//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

final class MessageCell: ChatCell {
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageBubble.layer.cornerRadius = 6
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:)))
        self.contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func populate(with message: Message) {
        super.populate(with: message)
        if let date = message.date {
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        
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
