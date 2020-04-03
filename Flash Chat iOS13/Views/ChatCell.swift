//
//  ChatCell.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 4/3/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    weak var viewController: ChatViewController?
    private(set) var message: Message?
    
    func populate(with message: Message) {
        self.message = message
    }
}
