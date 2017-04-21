//
//  SecondViewController.swift
//  LaDesign
//
//  Created by kai on 2017/4/11.
//  Copyright © 2017年 kai. All rights reserved.
//

import UIKit
import CoreBluetooth

class LightingModeViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    var _peripheral:CBPeripheral?
    var _characteristics:CBCharacteristic?
    let device_Name = "Arduino_BLE"
    let service_UUID = CBUUID(string:"FFE0")
    let characteristic_UUID = CBUUID(string: "FFE1")
    @IBOutlet weak var BTStatus: UILabel!
    
    var selectedColor: UIColor = UIColor.white
    @IBOutlet var colorPicker: SwiftHSVColorPicker!
    
    @IBOutlet weak var GotFireView: UIView!
    @IBOutlet weak var RandomView: UIView!
    @IBOutlet weak var RelaxView: UIView!
    @IBOutlet weak var BreathView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CBCentralManager(delegate: self, queue: nil)
        
        // Setup Color Picker
        colorPicker.setViewColor(selectedColor)
        
        // Mode view
        GotFireView.layer.cornerRadius = 8.0
        RandomView.layer.cornerRadius = 8.0
        RelaxView.layer.cornerRadius = 8.0
        BreathView.layer.cornerRadius = 8.0
        
        //selecting color notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendSelectingColor(_:)), name: NSNotification.Name("colorSelecting"), object: nil)
        
    }
    
    func sendSelectingColor(_ notification: Notification){
        let selectingColor = notification.object as! UIColor
        var R: CGFloat = 0, G: CGFloat = 0, B: CGFloat = 0, a: CGFloat = 0
        selectingColor.getRed(&R, green: &G, blue: &B, alpha: &a)
        
        let RGBString = String("RGB")?.data(using: String.Encoding.utf8)
        _peripheral?.writeValue(RGBString!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
        let Red = String(Int(R*225))
        let Rdata = Red.data(using: String.Encoding.utf8)
        _peripheral?.writeValue(Rdata!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
        let Green = String(Int(G*225))
        let Gdata = Green.data(using: String.Encoding.utf8)
        _peripheral?.writeValue(Gdata!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
        let Blue = String(Int(B*225))
        let Bdata = Blue.data(using: String.Encoding.utf8)
        _peripheral?.writeValue(Bdata!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
        print("red:\(Red), green:\(Green), blue:\(Blue)")
    }
    
    
////////////////////////////Bluetooth Setup//////////////////////////////
    //電腦藍牙
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            central.scanForPeripherals(withServices: nil, options: nil)
        }else{
            print("Bluetooth not available")
        }
    }
    //連結外圍藍牙裝置
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
        if device?.contains(device_Name) == true{
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            manager.connect(peripheral, options: nil)
            _peripheral = peripheral
            print("connect to Arduino_BLE sucessifully")
            BTStatus.text = "(BT connected)"
        }
    }
    //搜尋services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        
    }
    
    //搜尋到srvices，搜尋characters
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services!{
            let thisService = service as CBService
            
            if service.uuid == service_UUID{
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics!{
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == characteristic_UUID{
                self.peripheral.setNotifyValue(true, for: thisCharacteristic)
                _characteristics = thisCharacteristic
            }
        }
    }
////////////////////////////////////////////////////////////////////////
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first?.location(in: self.view)
        
        let ModeString = String("Mode").data(using: String.Encoding.utf8)
        _peripheral?.writeValue(ModeString!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
        
        if GotFireView.frame.contains(firstTouch!){
            let string = "M1"
            let data = string.data(using: String.Encoding.utf8)
            _peripheral?.writeValue(data!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
            print("M1")
        }
        
        if RandomView.frame.contains(firstTouch!){
            let string = "M2"
            let data = string.data(using: String.Encoding.utf8)
            _peripheral?.writeValue(data!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
            print("M2")
        }
        
        if RelaxView.frame.contains(firstTouch!){
            let string = "M3"
            let data = string.data(using: String.Encoding.utf8)
            _peripheral?.writeValue(data!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
            print("M3")
        }
        
        if BreathView.frame.contains(firstTouch!){
            let string = "M4"
            let data = string.data(using: String.Encoding.utf8)
            _peripheral?.writeValue(data!, for: _characteristics!, type: CBCharacteristicWriteType.withoutResponse)
            print("M4")
        }
    }
    
    

}

