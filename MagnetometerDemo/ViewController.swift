//
//  ViewController.swift
//  MagnetometerDemo
//
//  Created by shingo on 2019/05/07.
//  Copyright © 2019 codebase. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var magnetX: UILabel!
    @IBOutlet weak var magnetY: UILabel!
    @IBOutlet weak var magnetZ: UILabel!
    @IBOutlet weak var magnetTotal: UILabel!
    @IBOutlet weak var detectionButton: UIButton!
    
    @IBOutlet weak var calMagTotal: UILabel!
    @IBOutlet weak var calMagX: UILabel!
    @IBOutlet weak var calMagY: UILabel!
    @IBOutlet weak var calMagZ: UILabel!
    
    @IBOutlet weak var headingTotal: UILabel!
    @IBOutlet weak var headingX: UILabel!
    @IBOutlet weak var headingY: UILabel!
    @IBOutlet weak var headingZ: UILabel!
    
    
    // MotionManager
    let motionManager = CMMotionManager()
    
    // CLLocationManager
    var locationManager: CLLocationManager? = nil
    
    // Icons
    let startIcon = UIImage(named: "icon_start")
    let stopIcon = UIImage(named: "icon_stop")
    
    // Detection Status
    var isDetecting: Bool = false
    
    var updateMotionManagerHandler: CMMagnetometerHandler? = nil
    var updateDeviceMotionHandler: CMDeviceMotionHandler? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Start Icon
        isDetecting = false
        setDetectionAction()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if motionManager.isMagnetometerAvailable {
            // Set data acquisition interval
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.showsDeviceMovementDisplay = true
            
            // Getting data from CMMotionManager
            updateMotionManagerHandler = {(magnetoData: CMMagnetometerData?, error:Error?) -> Void in
                self.outputMagnetDataByMotionManager(magnet: magnetoData!.magneticField)
            }

            // Getting data from CMDeviceMotion
            //deviceMotion = motionManager.deviceMotion
            updateDeviceMotionHandler = {(deviceMotion: CMDeviceMotion?, error: Error?) -> Void in
                self.outputMagnetDataByDeviceMotion(magnet: self.motionManager.deviceMotion!.magneticField)
            }
        }
    }

    func outputMagnetDataByMotionManager(magnet: CMMagneticField){
        // Magnetometer
        magnetX.text = String(format: "%10f", magnet.x)
        magnetY.text = String(format: "%10f", magnet.y)
        magnetZ.text = String(format: "%10f", magnet.z)
        
        let total = sqrt(pow(magnet.x, 2) + pow(magnet.y, 2) + pow(magnet.z, 2))
        magnetTotal.text = String(format: "%10f", total)
    }

    func outputMagnetDataByDeviceMotion(magnet: CMCalibratedMagneticField){
        // Magnetometer
        calMagX.text = String(format: "%10f", magnet.field.x)
        calMagY.text = String(format: "%10f", magnet.field.y)
        calMagZ.text = String(format: "%10f", magnet.field.z)
        
        let total = sqrt(pow(magnet.field.x, 2) + pow(magnet.field.y, 2) + pow(magnet.field.z, 2))
        calMagTotal.text = String(format: "%10f", total)
    }

    
    // センサー取得を止める場合
    func stopMagnetometer(){
        if (motionManager.isMagnetometerAvailable) {
            motionManager.stopMagnetometerUpdates()
            motionManager.stopDeviceMotionUpdates()
        }
        locationManager?.stopUpdatingHeading()
    }
    
    func setDetectionAction(){
        if isDetecting {
            detectionButton.setImage(stopIcon, for: UIControl.State.normal)

            motionManager.startMagnetometerUpdates(to: OperationQueue.main, withHandler: updateMotionManagerHandler!)
            
            motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: OperationQueue.main, withHandler: updateDeviceMotionHandler!)

            locationManager?.startUpdatingHeading()
        }
        else {
            detectionButton.setImage(startIcon, for: UIControl.State.normal)
            stopMagnetometer()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingX.text = String(format: "%10f", newHeading.x)
        headingY.text = String(format: "%10f", newHeading.y)
        headingZ.text = String(format: "%10f", newHeading.z)
        
        let total = sqrt(pow(newHeading.x, 2) + pow(newHeading.y, 2) + pow(newHeading.z, 2))
        headingTotal.text = String(format: "%10f", total)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touchUpStartStopButton(_ sender: Any) {
        isDetecting = !isDetecting
        setDetectionAction()

    }
}

