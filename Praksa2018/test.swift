//
//  test.swift
//  Praksa2018
//
//  Created by Appmodule on 7/25/18.
//  Copyright © 2018 Appmodule. All rights reserved.
//

import UIKit
import CocoaMQTT
import Foundation


class test: CocoaMQTTDelegate {

    static let object = test() //singleton
    
    var mqtt : CocoaMQTT!
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print(message.string! + " " + message.topic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    }
    
    func _console(_ info: String) {
    }
    
    //setting up an MQTT connection
    func setUpMQTT() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        self.mqtt = CocoaMQTT(clientID: clientID, host: "siot.net", port: 1883)
        self.mqtt.keepAlive = 60
        self.mqtt.connect()
        mqtt.delegate = self
    }
    
    func publish (topic: String, message: String) {
        mqtt.publish(topic, withString: message, qos: CocoaMQTTQOS.qos0, retained: false, dup: false)
    }
    
    func unsubscribe(topic:String) {
        mqtt.unsubscribe(topic)
    }
    
    func subscribe(topic:String) {
        mqtt.subscribe(topic)
    }

}
