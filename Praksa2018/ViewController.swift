//
//  ViewController.swift
//  Praksa2018
//
//  Created by Appmodule on 7/17/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    let sensors = [
        ("Acceleration"),
        ("Geo Location"),
        ("Gyroscope")
    ]
    
    var myIndex = 0
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func logOutButton(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: "session")
        LogInControllerViewController.GUID.guid = ""
        preferences.set(false, forKey: "isLoggedIn")
        preferences.synchronize()
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
        
        //send a message that you're logged out
        let parameters = ["device" : "true"]
        guard let url = URL(string: "http://hq.appmodule.rs:2031/user/logout") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //sending as JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    //how many sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }

    //contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.titleLabel.text = sensors[indexPath.row]
        cell.switchButton.tag = indexPath.row
        cell.backgroundColor = .clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if (cell.switchButton.tag == 0) {
            if (TableViewCell.switchValue.accSwitch == true) {
                cell.switchButton.setOn(true, animated: false)
            }
        }
        if (cell.switchButton.tag == 1) {
            if (TableViewCell.switchValue.geoLocSwitch == true) {
                cell.switchButton.setOn(true, animated: false)
            }
        }
        if (cell.switchButton.tag == 2) {
            if (TableViewCell.switchValue.gyroSwitch == true) {
                cell.switchButton.setOn(true, animated: false)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        if (myIndex == 0) {
        self.performSegue(withIdentifier: "accelerometerSegue", sender: self)
        } else if (myIndex == 1) {
            self.performSegue(withIdentifier: "geoLocationSegue", sender: self)
        } else if (myIndex == 2) {
                self.performSegue(withIdentifier: "gyroscopeSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test.object.setUpMQTT()
        
}
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "Green Blue Gradient Android Wallpaper")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
    }
}

