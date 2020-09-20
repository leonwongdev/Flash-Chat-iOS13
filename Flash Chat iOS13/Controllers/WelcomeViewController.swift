//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel //remember to import cocoapod first

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //just before the view shows up
    override func viewWillAppear(_ animated: Bool) {
        //is a good practise to call the super method whenver you overriding a lifecycle function
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //just before another view shows up
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for char in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
//                self.titleLabel.text?.append(char)
//            }
//            charIndex += 1
//        }
       
        titleLabel.text = Constants.appName
        
        
    }
    

}
