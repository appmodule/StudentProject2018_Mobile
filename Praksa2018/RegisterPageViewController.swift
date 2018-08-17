//
//  RegisterPageViewController.swift
//  Praksa2018
//
//  Created by Appmodule on 7/18/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.delegate = self
        self.repeatPasswordField.delegate = self
        self.passwordField.inputView = UIView()
        self.repeatPasswordField.inputView = UIView()
        self.passwordField.becomeFirstResponder()
    }
    
    var passwordcount = 0
    var repeatpasswordcount = 0
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func numbers(_ sender: UIButton) {
        if (passwordField.isEditing) {
            if(passwordField.text?.count == 0) {
                passwordcount = 0
            }
            passwordField.text = passwordField.text! + String(sender.tag-1)
            passwordcount = passwordcount+1
            if (passwordcount == 4) {
                passwordField.resignFirstResponder()
                repeatPasswordField.becomeFirstResponder()
                if (repeatpasswordcount == 4) {
                self.registrationButtonTapped(self)
                }
            }
        } else if (repeatPasswordField.isEditing) {
            if(repeatPasswordField.text?.count == 0) {
                repeatpasswordcount = 0
            }
            repeatPasswordField.text = repeatPasswordField.text! + String(sender.tag-1)
            repeatpasswordcount = repeatpasswordcount+1
            if (repeatpasswordcount == 4) {
                self.repeatPasswordField.resignFirstResponder()
                self.passwordField.becomeFirstResponder()
                if (passwordcount == 4) {
                    self.registrationButtonTapped(self)
                }
            }
            }
        }
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        
        let password = passwordField.text
        let repeatpass = repeatPasswordField.text
        
        if (password != repeatpass) {
            displayMyAlertMessage(userMessage: "Passwords don't match!")
            passwordField.text = ""
            repeatPasswordField.text = ""
            passwordcount = 0
            repeatpasswordcount = 0
        }
        
        self.performSegue(withIdentifier: "registrationCompleteSegue", sender: self)
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okayAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okayAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}

