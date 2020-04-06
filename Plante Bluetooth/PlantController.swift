//
//  PlantController.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 05.04.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import UIKit

protocol plantControllerDelegate {
    func dismissPlanteController()
}

class PlantController: UIViewController, UIAdaptivePresentationControllerDelegate {

    // MARK: - Properties
    var delegate: plantControllerDelegate?
    var humiditySet = Int8()

    // MARK: - IBOutlets
    @IBOutlet var botScreenView: UIView!
    @IBOutlet var labelHumidity: UILabel!
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
        //Notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationKey),
        object: nil,
        queue: nil,
        using:catchNotification)
        
        botScreenView.layer.cornerRadius = 30
        // Do any additional setup after loading the view.
    }

    // MARK: - Set Up
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.dismissPlanteController()
    }
    
   func catchNotification(notification:Notification) -> Void {
     guard let humidity = notification.userInfo!["humidity"] else { return }
//     humiditySet = (Int8(humidity) / 1000)
     labelHumidity.text = "\(humidity)% Humide"
   }
    
    
    // MARK: - IBActions
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.dismissPlanteController()
            
        }
    }


    // MARK: - Navigation


    // MARK: - Network Manager calls


    // MARK: - Extensions
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    
}
