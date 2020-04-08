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
    let sizeScreen = UIScreen.main.bounds

    // MARK: - IBOutlets
    @IBOutlet var botScreenView: UIView!
    @IBOutlet var labelHumidity: UILabel!
    @IBOutlet var hauteurTextBubble: NSLayoutConstraint!
    @IBOutlet var labelBubble: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var bubbleSize: NSLayoutConstraint!
    @IBOutlet var textBubbleSize: NSLayoutConstraint!
    

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
        hauteurTextBubble.constant = -(sizeScreen.width * 0.08)
        bubbleSize.constant = -200
//        textBubbleSize.constant = -200
        labelBubble.isHidden = true
        descriptionLabel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.bubbleSize.constant = 0
            self.textBubbleSize.constant = 0
            self.view.layoutIfNeeded()
        })
        labelBubble.isHidden = false
        descriptionLabel.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    

    // MARK: - Set Up
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.dismissPlanteController()
    }
    
   func catchNotification(notification:Notification) -> Void {
        guard let humidity = notification.userInfo!["humidity"] else { return }
        guard let feel = notification.userInfo!["feel"] else { return }
        descriptionLabel.text = "Je suis actuellement à \(humidity)% d'humidité. Il est important que je ne reste pas désséchée..."
        labelBubble.text = "\(feel)"
    
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
