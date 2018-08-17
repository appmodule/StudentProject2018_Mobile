
# SSIOT starter for iOS (Summer internship 2018 - [AppModule](http://www.appmodule.net/))

SSIOT is a light application that turns your mobile device into a sensor that publishes data to the cloud using the MQTT protocol. SSIOT iOS works with [SSIOT frontend](https://github.com/appmodule/StudentProject2018_Frontend) and [SSIOT backend](https://github.com/appmodule/StudentProject2018_Backend)
# Short description
This application demonstrates using an iOS device as an IoT device, and provides a variety of events that it can publish data from.

The application can publish data to the following IoT event topics:

- Accelerometer
- Geo Location
- Gyroscope

The application can not receive data.

## References

  - [Architecture project](https://drive.google.com/open?id=1WVr8KbC6PKtnrh5wBTfyniAzzACREK-E)
  - [User manual](https://drive.google.com/open?id=122N9GOuM6Bzio5tibY7mOl9ZQWlqpxPc)

# How it works?
A device that is registered may publish data that is presented as an event using the MQTT protocol.

MQTT is a lightweight messaging protocol that supports publish/subscribe messaging. With MQTT, an application publishes messages to a topic. These messages may then be received by another application that is subscribed to that topic. This allows for a detached messaging network where the subscribers and publishers do not need to be aware of each other. The topics used by this application can be seen in the tables below:

Topics that receives the format of the data when sensors have been turned on:

| Topic | Sample topic | Sample message |
| ----- | ----- | ----- |
| ssiot/data/<GUID>/<sensorID> | ssiot/mnf/e9300c/accSensor | {"x": "1.0", "y": "1.0", "z": "1.0"} |
| ssiot/data/<GUID>/<sensorID> | ssiot/mnf/e9300c/geoSensor | {"x": "1.0", "y": "1.0"} |
| ssiot/data/<GUID>/<sensorID> | ssiot/mnf/e9300c/gyroSensor | {"x": "1.0", "y": "1.0", "z": "1.0"} |

Topics that receives real data when sensors are on:

|Topic | Sample topic | Sample message |
| ----- | ----- | ----- | 
| ssiot/data/<GUID>/<sensorID> | ssiot/data/e9300c/accSensor | {"x": "-3.9382", "y": "2.4859", "z": "7.93085"} |
| ssiot/data/<GUID>/<sensorID> | ssiot/data/e9300c/geoSensor | {"x": "35.499", "y": "-34.59388"} |
| ssiot/data/<GUID>/<sensorID> | ssiot/data/e9300c/gyroSensor | {"x": "-4.583098", "y": "5.4980982", "z": "2.49853"} |

# Setup

### Prerequisites

Required:

- Apple XCode

### Dependencies
- [CocoaMQTT](https://cocoapods.org/pods/CocoaMQTT) - for working with MQTT

### Frameworks
- [CoreMotion](https://developer.apple.com/documentation/coremotion)
- [CoreLocation](https://developer.apple.com/documentation/corelocation)


# Authors
- Jovana Majcen
