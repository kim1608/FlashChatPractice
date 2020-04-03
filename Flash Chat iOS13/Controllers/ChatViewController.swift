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
                K.FStore.bodyField: messageBody]) { (error) in
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

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as! MessageCell
        cell.populate(with: messages[indexPath.row])
        cell.viewController = self
        return cell

    }
    
}
