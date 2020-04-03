//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

var messageDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    return dateFormatter
}()

struct Message {
    let identifier: String
    let sender: String
    let body: String
    let imageURL: String?
    let date: Date?


    init(sender: String, body: String, identifier: String, imageURL: String? = nil, date: Date) {
        self.sender = sender
        self.body = body
        self.identifier = identifier
        self.imageURL = imageURL
        self.date = date
    }

    init?(rawMessageData: [String: Any], identifier: String) {
        guard let body = rawMessageData[K.FStore.bodyField] as? String,
            let sender = rawMessageData[K.FStore.senderField] as? String,
            let dateString = rawMessageData[K.FStore.dateField] as? String else {
            return nil
        }
        let imageURL = rawMessageData[K.FStore.imageURLField] as? String
        self.body = body
        self.sender = sender
        self.identifier = identifier
        self.imageURL = imageURL
        self.date = messageDateFormatter.date(from: dateString)
    }
}
