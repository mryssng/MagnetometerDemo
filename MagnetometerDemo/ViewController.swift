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

class ViewController: UIViewController {
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
    
    // Buttom icon images
    let startIcon = UIImage(named: "icon_start")
    let stopIcon = UIImage(named: "icon_stop")
    
    // Detection Status
    var isDetecting: Bool = false
    
    // Event handler
    var updateMotionManagerHandler: CMMagnetometerHandler? = nil
    var updateDeviceMotionHandler: CMDeviceMotionHandler? = nil
    
    // Timer for getting heading data
    var headingTimer: Timer?
    
    // Magnetometer update interval
    let updateInterval = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Start Icon
        isDetecting = false
        setDetectionAction()
        
        locationManager = CLLocationManager()
        locationManager?.headingFilter = kCLHeadingFilterNone
                
        if motionManager.isMagnetometerAvailable {
            // Set data acquisition interval
            motionManager.magnetometerUpdateInterval = updateInterval
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true
            
            // Getting data from CMMotionManager
            updateMotionManagerHandler = {(magnetoData: CMMagnetometerData?, error:Error?) -> Void in
                self.outputMagnetDataByMotionManager(magnet: magnetoData!.magneticField)
            }
            
            // Getting data from CMDeviceMotion
            updateDeviceMotionHandler = {(deviceMotion: CMDeviceMotion?, error: Error?) -> Void in
                self.outputMagnetDataByDeviceMotion(magnet: self.motionManager.deviceMotion!.magneticField)
            }
        }
    }
    
    // Show raw magneetometer data
    func outputMagnetDataByMotionManager(magnet: CMMagneticField) {
        // Magnetometer
        magnetX.text = String(format: "%10f", magnet.x)
        magnetY.text = String(format: "%10f", magnet.y)
        magnetZ.text = String(format: "%10f", magnet.z)
        
        let total = sqrt(pow(magnet.x, 2) + pow(magnet.y, 2) + pow(magnet.z, 2))
        magnetTotal.text = String(format: "%10f", total)
    }
    
    // Show calibrated magneetometer data
    func outputMagnetDataByDeviceMotion(magnet: CMCalibratedMagneticField) {
        // Magnetometer
        calMagX.text = String(format: "%10f", magnet.field.x)
        calMagY.text = String(format: "%10f", magnet.field.y)
        calMagZ.text = String(format: "%10f", magnet.field.z)
        
        let total = sqrt(pow(magnet.field.x, 2) + pow(magnet.field.y, 2) + pow(magnet.field.z, 2))
        calMagTotal.text = String(format: "%10f", total)
    }
    
    // Start getting sensor data
    func startMagnetometer() {
        motionManager.startMagnetometerUpdates(to: OperationQueue.main, withHandler: updateMotionManagerHandler!)
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: OperationQueue.main, withHandler: updateDeviceMotionHandler!)
        
        locationManager?.startUpdatingHeading()
        headingTimer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(ViewController.headingTimerUpdate), userInfo: nil, repeats: true)
    }
    
    // Stop getting sensor dsta
    func stopMagnetometer() {
        if (motionManager.isMagnetometerAvailable) {
            motionManager.stopMagnetometerUpdates()
            motionManager.stopDeviceMotionUpdates()
        }
        locationManager?.stopUpdatingHeading()
        headingTimer?.invalidate()
    }
    
    // Start/Stop button action
    func setDetectionAction() {
        if isDetecting {
            detectionButton.setImage(stopIcon, for: UIControl.State.normal)
            startMagnetometer()
        }
        else {
            detectionButton.setImage(startIcon, for: UIControl.State.normal)
            stopMagnetometer()
        }
    }
    
    // Timer function for headingTimer
    @objc func headingTimerUpdate() {
        let newHeading = self.locationManager?.heading
        let x = newHeading?.x ?? 0.0
        let y = newHeading?.y ?? 0.0
        let z = newHeading?.z ?? 0.0
        
        headingX.text = String(format: "%10f", x)
        headingY.text = String(format: "%10f", y)
        headingZ.text = String(format: "%10f", z)
        
        let total = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        headingTotal.text = String(format: "%10f", total)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Start/Stop button action
    @IBAction func touchUpStartStopButton(_ sender: Any) {
        isDetecting = !isDetecting
        setDetectionAction()
    }
}

