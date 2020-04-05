//
//  ViewController.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 03.04.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth



class ScanBluetooth: UIViewController {

    //MARK: - ASSETS
    @IBOutlet var ScanTableView: UITableView!
    
    
    
    //MARK: - PROPERITES
    var centralManager: CBCentralManager!
    var RSSIs = [NSNumber]()
    var peripherals: [CBPeripheral] = []
    var blePeripheral: CBPeripheral!
    let timer = Timer()
    var data = NSMutableData()
    var characteristicASCIIValue = NSString()
    var refreshControl = UIRefreshControl()
    var cellSelected = Bool()
    var cellIndexPath = IndexPath()
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScanTableView.delegate = self
        ScanTableView.dataSource = self
        ScanTableView.reloadData()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        ScanTableView.separatorStyle = .none
        ScanTableView.layer.cornerRadius = 24
        
       //Refresh when pull
        refreshControl.tintColor = UIColor(red: 29.0/255.0, green: 28.0/255.0, blue: 39.0/255.0, alpha: 1)
       ScanTableView.refreshControl = refreshControl
       refreshControl.addTarget(self, action: #selector(refreshScan), for: UIControl.Event.valueChanged)
       ScanTableView.addSubview(refreshControl)
        
    }
    
    

    
    @objc func refreshScan(){
            self.disconnectFromDevice()
            self.peripherals = []
            self.RSSIs = []
            self.startScan()
            self.ScanTableView.reloadData()
        
    }
    
    func startScan(){
        print("Now Scanning...")
        timer.invalidate()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.cancelScan), userInfo: nil, repeats: false)
        
        
    }
    
    func stopScan(){
        
    }
    
    @objc func cancelScan(){
        self.ScanTableView.reloadData()
        refreshControl.endRefreshing()
        self.centralManager?.stopScan()
        print("Scan Stopped")
        print("Number of Peripherals Found: \(peripherals.count)")
    }
    
    func disconnectFromDevice () {
        if blePeripheral != nil {
            centralManager?.cancelPeripheralConnection(blePeripheral)
            ScanTableView.deselectRow(at: cellIndexPath, animated: true)
            ScanTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlant" {
            let destinationVC = segue.destination as! PlantController
            destinationVC.delegate = self
            
        }
    }


}

extension ScanBluetooth: CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource, cellDelegate,plantControllerDelegate {
        
    
    func dismissPlanteController() {
        refreshScan()
    }
    
    func cellSelected(cell: ScanBluetoothCell) {
        cellIndexPath = self.ScanTableView.indexPath(for: cell)!
        
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("Blutetooth Enable")
            startScan()
        } else {
            print("Blutetooth disable")
            let alertVC = UIAlertController(title: "Blutooth non activé", message: "Le bluetooth doit être activé pour utiliser cette application", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        stopScan()
        peripherals.append(peripheral)
        RSSIs.append(RSSI)
        ScanTableView.reloadData()
    
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("*****************************")
        print("Connection complete")
        centralManager?.stopScan()
        print("Scan Stopped")
        blePeripheral = peripheral
        
       //Erase data that we might have
        data.length = 0
       
       //Discovery callback
        blePeripheral.delegate = self
        peripheral.discoverServices(nil)
        performSegue(withIdentifier: "toPlant", sender: self)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")
        guard let services = peripheral.services else {return}
        for service in services {
            print(service)
            peripheral.discoverCharacteristics([humidity_UUID], for: service)
        }

              
    }
//
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

            print("*******************************************************")
            guard let characteristics = service.characteristics else {return}
            for characteristic in characteristics {
                print(characteristic)
                if characteristic.properties.contains(.read){
                    print("\(characteristic.uuid): properties contains .read")
                    peripheral.readValue(for: characteristic)
                }
                if characteristic.properties.contains(.notify){
                    print("\(characteristic.uuid): properties contains .notify")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            
    }
//
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
          case humidity_UUID:
            if let ASCIIstring = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) {
                characteristicASCIIValue = ASCIIstring
                print("Value Recieved: \((characteristicASCIIValue as String))")
                //NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: nil)
                
            }
          default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScanBluetoothCell
        cell.delegate = self
        cell.layer.cornerRadius = 24
        cell.rssiNumber.text = "\(RSSIs[indexPath.section])"
        
        
        if Int(RSSIs[indexPath.section]) < -70 {
            cell.rssiState.image = UIImage(named: "Top Connection")
        } else if Int(RSSIs[indexPath.section]) > -70 && Int(RSSIs[indexPath.section]) < -60 {
            cell.rssiState.image = UIImage(named: "Top Medium Connection")
        } else if Int(RSSIs[indexPath.section]) > -60 && Int(RSSIs[indexPath.section]) < -50 {
            cell.rssiState.image = UIImage(named: "Medium Connection")
        } else {
            cell.rssiState.image = UIImage(named: "Bot Connection")
        }
        
        if peripherals[indexPath.section].name == nil {
            cell.labelCell.text = "Inconnu"
        } else {
            cell.labelCell.text = peripherals[indexPath.section].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centralManager.connect(peripherals[indexPath.section], options: nil)
        
    }
    
    
   
    
}

