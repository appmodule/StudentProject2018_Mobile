//
//  NewViewController.swift
//  Praksa2018
//
//  Created by Appmodule on 7/17/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit
import CoreLocation

class NewViewController: UIViewController {

    
    @IBOutlet weak var secondsSliderAcc: UISlider!
    @IBOutlet weak var meterSliderGeo: UISlider!
    @IBOutlet weak var secondsSliderGeo: UISlider!
    @IBOutlet weak var secondsSliderGyro: UISlider!
    
    @IBOutlet weak var sensorUsed: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!

    @IBOutlet weak var labelOneAcc: UILabel!
    @IBOutlet weak var labelOneGeo: UILabel!
    @IBOutlet weak var labelTwoGeo: UILabel!
    @IBOutlet weak var labelOneGyro: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 10
        popUpView.layer.cornerRadius = 25
        if ( restorationIdentifier == "acceleration"){
        labelOneAcc.text = String(format: "In every %i sec", Trigeri.sekundeAcc)
            secondsSliderAcc.value = Float(Trigeri.sekundeAcc)
        }
        if ( restorationIdentifier == "geoLocation") {
        labelOneGeo.text = String(format: "When value change for %i m", Trigeri.metriGeo)
            meterSliderGeo.value = Float(Trigeri.metriGeo)
        labelTwoGeo.text = String(format: "In every %i sec", Trigeri.sekundeGeo)
            secondsSliderGeo.value = Float(Trigeri.sekundeGeo)
        }
        if ( restorationIdentifier == "gyroscope") {
            labelOneGyro.text = String(format: "In every %i sec", Trigeri.sekundeGyro)
            secondsSliderGyro.value = Float(Trigeri.sekundeGyro)
        }
    }
    
    @IBAction func secondsAcc(_ sender: UISlider) {
        self.secondsSliderAcc.isContinuous = false
        var sliderValue = Trigeri.sekundeAcc
        sliderValue = lroundf(sender.value)
        Trigeri.sekundeAcc = sliderValue
        labelOneAcc.text = "In every \(sliderValue) sec"
        TableViewCell.manager.motionManagerA.accelerometerUpdateInterval = TimeInterval(Trigeri.sekundeAcc)
    }
    
    
    @IBAction func metersGeo(_ sender: UISlider) {
        self.meterSliderGeo.isContinuous = false
        var sliderValue = Trigeri.metriGeo
        sliderValue = lroundf(sender.value)
        labelOneGeo.text = "When value change for \(sliderValue) m"
        Trigeri.metriGeo = sliderValue
        TableViewCell.manager.locationManager.distanceFilter = CLLocationDistance(sliderValue)
    }
    
    @IBAction func secondsGeo(_ sender: UISlider) {
        self.secondsSliderGeo.isContinuous = false
        var sliderValue = Trigeri.sekundeGeo
        sliderValue = lroundf(sender.value)
        Trigeri.sekundeGeo = sliderValue
        labelTwoGeo.text = "In every \(sliderValue) sec"
        TableViewCell.timerr.timer.invalidate()
        TableViewCell().startTimer()
    }
    @IBAction func secondsGyro(_ sender: UISlider) {
        self.secondsSliderGyro.isContinuous = false
        var sliderValue = Trigeri.sekundeGyro
        sliderValue = lroundf(sender.value)
        Trigeri.sekundeGyro = sliderValue
        labelOneGyro.text = "In every \(sliderValue) sec"
        TableViewCell.manager.motionManagerG.gyroUpdateInterval = TimeInterval(sliderValue)
    }
    
    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    struct Trigeri {
        static var sekundeAcc = 5
        static var sekundeGeo = 5
        static var metriGeo = 50
        static var sekundeGyro = 5
    }
  
}


