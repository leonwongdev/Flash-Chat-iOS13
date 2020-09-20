//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var userNameTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let username = userNameTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("THERE IS ERROR : \(e.localizedDescription)")
                }
                else {
                    // Navigate to ChatViewController
                    print("User Registered successfully")
                    
                    //save the username.
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: { (error) in
                        if let e = error {
                            print("THERE IS ERROR : \(e.localizedDescription)")
                        } else {
                            print("User display created.")
                        }
                    })
                    
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                    
                    
                }
            }
            
        }
    }
}

