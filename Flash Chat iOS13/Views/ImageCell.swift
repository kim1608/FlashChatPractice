//
//  ImageCell.swift
//  Flash Chat iOS13
//
//  Created by Marko Ljubevski on 4/3/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

final class ImageCell: ChatCell {
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    override func populate(with message: Message) {
        super.populate(with: message)
        
        guard let imageURLString = message.imageURL,
            let imageURL = URL(string: imageURLString) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.messageImageView.image = image
                }
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageImageView.image = nil
    }
}
