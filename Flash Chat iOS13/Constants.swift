//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

struct K {
    static let appName = "⚡️FlashChat"
    static let messageCellIdentifier = "MessageCell"
    static let imageCellIdentifier = "imageCell"
    static let messageCellNibName = "MessageCell"
    static let imageCellNibName = "imageCel"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let imageURLField = "imageURL"
    }
}
