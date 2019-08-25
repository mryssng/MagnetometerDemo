# Magnetometer Demo for iOS

This repository is demonstration app of getting magnetometer data for iOS.

This app is a sample to get magnetic sensor data on iOS.
iOS provides three types of magnetic sensor data.
- [Core Motion framework](https://developer.apple.com/documentation/coremotion)  
[CMMagnetometerData](https://developer.apple.com/documentation/coremotion/cmmagnetometerdata) class in CMMotionManagers provides raw magnetic field data.
- [CMDeviceMotion](https://developer.apple.com/documentation/coremotion/cmdevicemotion#//apple_ref/doc/c_ref/CMDeviceMotion)  
[CMCalibratedMagneticField](https://developer.apple.com/documentation/coremotion/cmcalibratedmagneticfield) structure in CMDeviceMotion provides calibrated magnetic field data.(Corrected for device bias)
- [Core Location framework](https://developer.apple.com/documentation/corelocation)  
[CLHeading](https://developer.apple.com/documentation/corelocation/clheading) class provides corrected for device bias and filtered to eliminate local external magnetic field data.

## License
Magnetometer Demo for iOS is distributed under the standard [MIT license](https://github.com/mryssng/MagnetometerDemo/blob/master/LICENSE).
