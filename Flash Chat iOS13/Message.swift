//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

struct Message {
    let identifier: String
    let sender: String
    let body: String
    let imageURL: String?

    init(sender: String, body: String, identifier: String, imageURL: String? = nil) {
        self.sender = sender
        self.body = body
        self.identifier = identifier
        self.imageURL = imageURL
    }
    
    
    init?(rawMessageData: [String: Any], identifier: String) {
        guard let body = rawMessageData[K.FStore.bodyField] as? String,
            let sender = rawMessageData[K.FStore.senderField] as? String else {
            return nil
        }
        let imageURL = rawMessageData[K.FStore.imageURLField] as? String
        
        self.body = body
        self.sender = sender
        self.identifier = identifier
        self.imageURL = imageURL
    }
}
