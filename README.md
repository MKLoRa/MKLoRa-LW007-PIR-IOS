# LW007-PIR iOS Software Development Kit Guide

* This SDK only support devices based on LW007-PIR.

## Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let’s take a look at the related classes and the relationships between them.

`MKPIRCentralManager`：global manager, check system’s bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKPIRInterface`: When the device is successfully connected, the device data can be read through the interface in `MKPIRInterface `;

`MKPIRInterface+MKPIRConfig`: When the device is successfully connected, you can configure the device data through the interface in `MKPIRInterface+MKPIRConfig`;


## Scanning Stage

in this stage, `MKPIRCentralManager` will scan and analyze the advertisement data of LW007 devices.


## Connection Stage

The device broadcast information includes whether a password is required when connecting.

1.Enter the password to connect, then call the following method to connect:
`connectPeripheral:password:sucBlock:failedBlock:`
2.You do not need to enter a password to connect, call the following method to connect:
`connectPeripheral:sucBlock:failedBlock:`


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-PIR is available through CocoaPods.To install it, simply add the following line to your Podfile, and then import <MKLoRaWAN-PIR/MKPIRSDK.h>:

**pod 'MKLoRaWAN-PIR/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to “info.plist” file of your project: Privacy - Bluetooth Peripheral Usage Description - “your description”. as the screenshot below.</font>

*  <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project’s info.plist file: Privacy-Bluetooth Always Usage Description-“Your usage description”.</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKPIRCentralManager *manager = [MKPIRCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.Set the scan delegate and complete the related delegate methods.

```
manager.delegate = self;
```

* 2.you can start the scanning task in this way:

```
[manager startScan];
```

* 3.at the sometime, you can stop the scanning task in this way:

```
[manager stopScan];
```

#### 2.Connect to device

The `MKPIRCentralManager ` contains the method of connecting the device.

```
/// Connect device function
/// @param trackerModel Model
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
```

```
/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, and the connection status of the device. If you want to monitor the changes of these two states, you can register the following notifications to achieve:

* When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_pir_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKPIRCentralManager shared] centralStatus];
```

* When the device connection status changes， <font color=#FF0000 face="黑体"> `mk_pir_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

```
[MKPIRCentralManager shared].connectState;
```

#### 4.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_pir_deviceDisconnectTypeNotification` </font> notifications to monitor data.


```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_pir_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /*
    After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02, the device has no data communication for two consecutive minutes, it returns 0x03, and the shutdown protocol is sent to make the device shut down and return 0x04.
    */
}
```

#### 5.Monitoring device PIR sensor status changes.

##### 1.Start monitoring `[[MKPIRCentralManager shared] notifyPirSensorData:YES];`
##### 2.Register for <font color=#FF0000 face="黑体"> `mk_pir_pirStatusNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receivePIRStatus:)
                                                         name:mk_pir_pirStatusNotification
                                                       object:nil];

```

```
#pragma mark - notes
- (void)receivePIRStatus:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo) || !self.dataModel.isOn) {
        return;
    }
    BOOL detected = [userInfo[@"detected"] boolValue];
    if (detected) {
        //Motion detected
    }else {
        //Motion not detected
    }
    
}
```

#### 6.Monitor the status change of the door sensor of the device.

##### 1.Start monitoring `[[MKPIRCentralManager shared] notifyDoorSensorData:YES];`
##### 2.Register for <font color=#FF0000 face="黑体"> `mk_pir_doorSensorDatasNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveDoorSensorStatus:)
                                                         name:mk_pir_doorSensorDatasNotification
                                                       object:nil];

```

```
#pragma mark - notes
- (void)receiveDoorSensorStatus:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL open = [userInfo[@"open"] boolValue];
    if (open) {
        //Open
    }else {
        //Closed
    }
}
```

#### 7.Monitoring temperature and humidity sensor data
##### 1.Start monitoring `[[MKPIRCentralManager shared] notifyTHSensorData:YES];`
##### 2.Register for <font color=#FF0000 face="黑体"> `mk_pir_thSensorDatasNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveTHDatas:)
                                                         name:mk_pir_thSensorDatasNotification
                                                       object:nil];

```

```
#pragma mark - notes
- (void)receiveTHDatas:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo) || !self.dataModel.isOn) {
        return;
    }
    
}
```

#### 8.Device log
##### 1.Start monitoring `[[MKPIRCentralManager shared] notifyLogData:YES];`
##### 2.Config logDelegate.
##### 3.Implement the corresponding `mk_pir_centralManagerLogDelegate` method

```
#pragma mark - mk_pir_centralManagerLogDelegate
- (void)mk_pir_receiveLog:(NSString *)deviceLog {
    //Log
}
```


# Change log

* 20220520 first version;
