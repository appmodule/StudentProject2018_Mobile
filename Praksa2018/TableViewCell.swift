//
//  TableViewCell.swift
//  Praksa2018
//
//  Created by Appmodule on 7/17/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion
import CocoaMQTT

class TableViewCell: UITableViewCell, CLLocationManagerDelegate {
    
    struct timerr {
    static var timer = Timer()
    }
    
    struct manager {
        static var motionManagerA = CMMotionManager()
        static var locationManager = CLLocationManager()
        static var motionManagerG = CMMotionManager()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    struct switchValue {
        static var accSwitch = false
        static var geoLocSwitch = false
        static var gyroSwitch = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] //the newest location
        outputGeoLocData(location: location)
    }
    
    @objc func timerCallBack(timer: Timer) {
        if(NewViewController.Trigeri.sekundeGeo != 0) {
        manager.locationManager.pausesLocationUpdatesAutomatically = true
        manager.locationManager.pausesLocationUpdatesAutomatically = false
        outputGeoLocData(location: manager.locationManager.location!)
        }
    }
    
    func startTimer() {
        let bla = #selector(TableViewCell.timerCallBack(timer:))
        timerr.timer = Timer.scheduledTimer(timeInterval: TimeInterval(NewViewController.Trigeri.sekundeGeo), target: self, selector: (bla), userInfo: nil, repeats: true)
    }

    @IBAction func switchOn(_ sender: UISwitch) {
        if (switchButton.isOn) {
            if((switchButton.tag) == 0) {
                switchValue.accSwitch = true
                
                //sending json
                let parameters = ["x": "1.0", "y": "1.0", "z": "1.0"]
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/accSensor") else { return }
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
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
                        } catch {
                           // print(error)
                        }
                    }
                    }.resume()
                
                manager.motionManagerA.accelerometerUpdateInterval = TimeInterval(NewViewController.Trigeri.sekundeAcc)
                manager.motionManagerA.startAccelerometerUpdates(to: OperationQueue.current!) {
                    (data: CMAccelerometerData! ,error) in if (data) != nil {
                        self.outputAccelerationData(acceleration: data.acceleration)
                    }
                }
            }
            if ((switchButton.tag) == 1) {
                 switchValue.geoLocSwitch = true
                //sending json
                let parameters = ["x": "1.0", "y": "1.0"]
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/geoSensor") else { return }
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
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                    do {
                        _ = try JSONSerialization.jsonObject(with: data, options: [])
                        //print(json)
                    } catch {
                        print(error)
                        }
                    }
                }.resume()
                
                manager.locationManager.delegate = self
                manager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                manager.locationManager.requestWhenInUseAuthorization()
                manager.locationManager.startUpdatingLocation()
                manager.locationManager.pausesLocationUpdatesAutomatically = false
                manager.locationManager.distanceFilter = CLLocationDistance(NewViewController.Trigeri.metriGeo)
                startTimer()
            }

            if ((switchButton.tag) == 2) {
                switchValue.gyroSwitch = true
                
                //sending json
                let parameters = ["x": "1.0", "y": "1.0", "z": "1.0"]
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/gyroSensor") else { return }
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
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                        do {
                            _ = try JSONSerialization.jsonObject(with: data, options: [])
                            //print(json)
                        } catch {
                            print(error)
                        }
                    }
                    }.resume()
                manager.motionManagerG.gyroUpdateInterval = TimeInterval(NewViewController.Trigeri.sekundeGyro)
                manager.motionManagerG.startGyroUpdates(to: OperationQueue.current!){
                    (data: CMGyroData!,error) in if (data) != nil{
                        self.outputGyroData(rotation: data.rotationRate)
                   }
                }
            }
        } else {
            if ((switchButton.tag) == 0){
                switchValue.accSwitch = false
                manager.motionManagerA.stopAccelerometerUpdates()
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/accSensor" + "/off") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let session = URLSession.shared
                session.dataTask(with: request) {
                    (data, response, error) in
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                        do {
                            _ = try JSONSerialization.jsonObject(with: data, options: [])
                            //print(json)
                        } catch {
                            print(error)
                        }
                    }
                    }.resume()
                }
            if ((switchButton.tag) == 1){
                switchValue.geoLocSwitch = false
                timerr.timer.invalidate()
                manager.locationManager.stopUpdatingLocation()
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/geoSensor" + "/off") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let session = URLSession.shared
                session.dataTask(with: request) {
                    (data, response, error) in
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                        do {
                            _ = try JSONSerialization.jsonObject(with: data, options: [])
                            //print(json)
                        } catch {
                            print(error)
                        }
                    }
                    }.resume()
            }
            if ((switchButton.tag) == 2){
                switchValue.gyroSwitch = false
                manager.motionManagerG.stopGyroUpdates()
                guard let url = URL(string: "http://hq.appmodule.rs:2031/ssiot/mnf/" + LogInControllerViewController.GUID.guid + "/gyroSensor" + "/off") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let session = URLSession.shared
                session.dataTask(with: request) {
                    (data, response, error) in
                    if response != nil {
                        //print(response)
                    }
                    if let data = data {
                        do {
                            _ = try JSONSerialization.jsonObject(with: data, options: [])
                            //print(json)
                        } catch {
                            print(error)
                        }
                    }
                    }.resume()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    struct GlobalVariable {
        static var latitude = String()
        static var longitude = String()
    }
    
    //taking geoLoc data
    func outputGeoLocData(location : CLLocation) {
        if (LogInControllerViewController.GUID.guid != "") {
        if(manager.locationManager.distanceFilter != 0.00) {
        GlobalVariable.longitude = String(manager.locationManager.location!.coordinate.longitude)
        GlobalVariable.latitude = String(manager.locationManager.location!.coordinate.latitude)
        test.object.publish(topic: "ssiot/data/" + LogInControllerViewController.GUID.guid + "/geoSensor", message: ("{\"long\":" + GlobalVariable.longitude + ",\"lat\":" + GlobalVariable.latitude + "}"))
        }
    }
    }
    
    //taking acceleration data
    func outputAccelerationData(acceleration: CMAcceleration) {
        if (LogInControllerViewController.GUID.guid != ""){
        if (NewViewController.Trigeri.sekundeGeo != 0) {
        if (manager.motionManagerA.accelerometerUpdateInterval != 0.01) {
        var accx : String
        var accy : String
        var accz : String
        accx = String(acceleration.x)
        accy = String(acceleration.y)
        accz = String(acceleration.z)
            test.object.publish(topic: "ssiot/data/" + LogInControllerViewController.GUID.guid + "/accSensor", message: ("{\"x\":" + accx + ",\"y\":" + accy + ",\"z\":" + accz + "}"))
            }
        }
        }
    }
    
    //taking gyro data
    func outputGyroData(rotation: CMRotationRate){
        if (LogInControllerViewController.GUID.guid != ""){
        if (manager.motionManagerG.gyroUpdateInterval != 0.01) {
        var accx : String
        var accy : String
        var accz : String
        accx = String(rotation.x)
        accy = String(rotation.y)
        accz = String(rotation.z)
        test.object.publish(topic: "ssiot/data/" + LogInControllerViewController.GUID.guid + "/gyroSensor", message: ("{\"x\":" + accx + ",\"y\":" + accy + ",\"z\":" + accz + "}"))
        }
        }
    }
}
