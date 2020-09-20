//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore() // important. First Step
    var messages: [Message] = [] //testing
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self // trigger the delegate method UITableViewDataSource
        // tableView.delegate = self
        
        title = "⚡️Chat Room" // create a title in the navigation bar
        navigationItem.hidesBackButton = true //hide the back button in Chat Room
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier) // set the xib identifier to be the same as Table View Cell
        
        loadMessages()
        
    }
    
    func loadMessages() {
        
        
        
        // addSnapshotListener allows the firestore to listen for changes
        // sorting the document by date
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = [] // empty the dummy array
            if let e = error {
                print("There was a error retrieving data from firestore, \(e)")
            } else {
                //querySnapshot?.documents[0].data()[Constants.FStore.senderField]
                
                if let snapShotDocuments = querySnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String, let senderUsername = data[Constants.FStore.userNameField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody, username: senderUsername)
                            self.messages.append(newMessage) // turn firestore data to swift object.
                            
                            DispatchQueue.main.async {
                                //make suure it the code is running in the foreground.
                                //All updates to the user interface must be done on the main thread to keep the app responsive to the user.
                                self.tableView.reloadData() //sometimes the data may not be added in time to be shown in tableView. This line of code triggers the UITableViewDataSource
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0) // messages.count - 1 to get the last index of the array.
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                            }
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email, let senderUsername = Auth.auth().currentUser?.displayName {
            
            // textfield and sender could be empty so we need optional binding
            
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970,
                Constants.FStore.userNameField: senderUsername
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = "" // add self to method and put in on main thread so it can update the UI
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true) // go back to root View Controller if logged out successfully
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    //UITableViewDataSource is for populating the tableView, how many cells and which cells to be put
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // how many cells do you want in the table view.
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //This method is called as many time as the number of cell returned in the above method.
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell // downcasting the UITableViewCell to a MessageCell Class
        cell.label.text = message.body      //the label in cell.label.text here is from MessageCell Class
        
        //This is a message from current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.userNameLabel.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
            cell.userNameLabel.text = "You"
            cell.userNameLabel.textColor = UIColor(named: Constants.BrandColors.blue)
            
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.userNameLabel.isHidden = false
            cell.userNameLabel.text = message.username
            cell.userNameLabel.textColor = UIColor(red: 0.2941, green: 0.8471, blue: 0.3882, alpha: 1.0) /* #4bd863 */
            
            cell.messageBubble.backgroundColor = UIColor(red: 0.8118, green: 0.9725, blue: 0.9882, alpha: 1.0) /* #cff8fc */
            cell.label.textColor = UIColor(red: 0.0431, green: 0.5373, blue: 0.8667, alpha: 1.0) /* #0b89dd */
            //            let creationDate = Auth.auth().currentUser?.metadata.creationDate
            //            let creationDateTimeInterval = creationDate?.timeIntervalSince1970
            //            let intDate = Int(creationDateTimeInterval!)
            //            let newImage = textToImage(drawText: "\(intDate)", inImage: #imageLiteral(resourceName: "YouAvatar"), atPoint: CGPoint(x: 6, y: 11))
            //            cell.leftImageView.image = newImage
        }

        return cell
    }
    
}

//extension ChatViewController: UITableViewDelegate{
//    //handle interactivity
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}

//func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
//    let textColor = UIColor.black
//    let textFont = UIFont(name: "Helvetica Bold", size: 12)!
//
//    let scale = UIScreen.main.scale
//    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
//
//    let textFontAttributes = [
//        NSAttributedString.Key.font: textFont,
//        NSAttributedString.Key.foregroundColor: textColor,
//        ] as [NSAttributedString.Key : Any]
//    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
//
//    let rect = CGRect(origin: point, size: image.size)
//    text.draw(in: rect, withAttributes: textFontAttributes)
//
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//
//    return newImage!
//}
