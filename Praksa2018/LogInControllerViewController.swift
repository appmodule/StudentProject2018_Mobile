//
//  LogInControllerViewController.swift
//  Praksa2018
//
//  Created by Appmodule on 7/27/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit

class LogInControllerViewController: UIViewController {

    let login_url = "http://hq.appmodule.rs:2031/user/login" //to send username and pass info
    
    struct GUID {
        static var guid = ""
    }
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _loginButton: UIButton!
    
    @IBAction func DoLogin(_ sender: UIButton) {
        let username = _username.text
        let password = _password.text
        if (username == "" || password == "") {
            return
        }
        LogIn(username!, password!)
    }
    
    //sending user and password and opening a session
    func LogIn(_ user: String, _ pass:String){
        
        let post_data: NSDictionary = NSMutableDictionary()
        post_data.setValue(user, forKey: "username")
        post_data.setValue(pass, forKey: "password")
        
        let url:URL = URL(string: login_url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        var paramString = ""

        for (key, value) in post_data {
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
    
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
        
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                return
            }
            //catching data
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json!)
            }
            catch{
                return
            }
            guard let server_response = json as? NSDictionary else {
                return
            }
            if let error_block = server_response["error"] as? Int {
                if (error_block == 1) {
                    DispatchQueue.main.async(execute: {
                        self.displayMyAlertMessage(userMessage: "Wrong credentials!")
                        self._username.text = ""
                        self._password.text = ""
                        self._password.resignFirstResponder()
                        self._username.becomeFirstResponder()
                    })
                }
            }
            if let data_block = server_response["body"] as? NSDictionary {
                if let session_data = data_block["guid"] as? String {
                    GUID.guid = session_data
                    let preferences = UserDefaults.standard
                    preferences.set(GUID.guid, forKey: "session")
                    preferences.set(true, forKey: "isLoggedIn")
                    preferences.synchronize()
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "logInSegue", sender: self)
                    }
                }
            }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._username.becomeFirstResponder()
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "session") != nil) {
           GUID.guid = preferences.object(forKey: "session") as! String
        }
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okayAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okayAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
