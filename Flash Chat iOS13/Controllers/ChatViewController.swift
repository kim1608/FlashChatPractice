//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageViewBottomPin: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    // MARK: - Inherited methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextfield.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.messageCellNibName, bundle: Bundle.main), forCellReuseIdentifier: K.messageCellIdentifier)
        tableView.register(UINib(nibName: K.imageCellNibName, bundle: Bundle.main), forCellReuseIdentifier: K.imageCellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadMessages()
    }
    
    // MARK: - Instance methods
    
    func loadMessages() {
        messages = []
        
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an issue, retrieving data from firestore \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        if let message = Message(rawMessageData: doc.data(), identifier: doc.documentID) {
                            self.messages.append(message)
                        }
                    }
                    let message = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://www.novosti.rs/upload/images/2015//06/08/bas-bunar.jpg", date: Date())
                    self.messages.append(message)
                    let message1 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://www.novosti.rs/upload/images/2016%20II//08/29/novina/basta%20(3).jpg", date: Date())
                    self.messages.append(message1)
                    let message2 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://uredjenjedoma.rs/wp-content/uploads/2018/08/bunar-1-novo.jpg", date: Date())
                    self.messages.append(message2)
                    let message3 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://lh3.googleusercontent.com/proxy/e46I7XY8DhQUdK6gZX285aDmU9n0kSghoWMDlkPxQ57wAwRlManfe8DGKguGxFtYeA7GHjXe59t0awIpC8PI", date: Date())
                    self.messages.append(message3)
                    let message4 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://images.kupujemprodajem.com//photos/oglasi/6/96/90782966/big-90782966_5e434602d9cb97-378694171581467076803.jpg", date: Date())
                    self.messages.append(message4)
                    let message5 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://radiogradacac.ba/wp-content/uploads/2018/08/BUNAR-4-RG.jpg", date: Date())
                    self.messages.append(message5)
                    let message6 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://www.novosti.rs/upload/images/2016%20II//08/29/novina/basta%20(3).jpg", date: Date())
                    self.messages.append(message6)
                    let message7 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://uredjenjedoma.rs/wp-content/uploads/2018/08/bunar-1-novo.jpg", date: Date())
                    self.messages.append(message7)
                    let message8 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://lh3.googleusercontent.com/proxy/e46I7XY8DhQUdK6gZX285aDmU9n0kSghoWMDlkPxQ57wAwRlManfe8DGKguGxFtYeA7GHjXe59t0awIpC8PI", date: Date())
                    self.messages.append(message8)
                    let message9 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://images.kupujemprodajem.com//photos/oglasi/6/96/90782966/big-90782966_5e434602d9cb97-378694171581467076803.jpg", date: Date())
                    self.messages.append(message9)
                    let message10 = Message(sender: "milos@ljubevski.com", body: "Milos", identifier: UUID().uuidString, imageURL: "https://radiogradacac.ba/wp-content/uploads/2018/08/BUNAR-4-RG.jpg", date: Date())
                    self.messages.append(message10)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func deleteMessage(message: Message) {
        db.collection(K.FStore.collectionName).document(message.identifier).delete { (error) in
            if error == nil {
                // delete message
                
                let index = self.messages.firstIndex { (currentMessege) in
                    return currentMessege.identifier == message.identifier
                }
                
                if let index = index {
                    self.messages.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func sendPressed(_ sender: UIButton?) {
        
        
        if let messageBody = messageTextfield.text,
            !messageBody.isEmpty, 
            let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: messageDateFormatter.string(from: Date())]) { (error) in
                    if let error = error {
                        print("There was an issue, saving data to firestore, \(error)...")
                    } else {
                        print("Successfully saved data.")
//                        let message = Message(sender: messageSender, body: messageBody)
//                        self.messages.append(message)
//                        self.tableView.reloadData()
                        self.messageTextfield.text = ""
                        self.loadMessages()
                    }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

        
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPressed(nil)
        return true
    }
    
    // MARK: - Private Methods
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardHeight = keyboardFrameValue.cgRectValue.size.height
        
        self.messageViewBottomPin.constant = keyboardHeight
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        self.messageViewBottomPin.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let identifier: String
        if message.imageURL != nil {
            identifier = K.imageCellIdentifier
        } else {
            identifier = K.messageCellIdentifier
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatCell
        cell.populate(with: messages[indexPath.row])
        cell.viewController = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        
        if message.imageURL == nil {
            return UITableView.automaticDimension
        } else {
            return 240.0
        }
    }
    
}
