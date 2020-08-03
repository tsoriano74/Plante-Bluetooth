//
//  DescriptionViewController.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 02.08.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DescriptionViewController: UIViewController {

    
    // MARK: - Properties

    
    var imageFromUser = UIImage()
    var plantFound = String()

    // MARK: - IBOutlets
    @IBOutlet var plantImage: UIImageView!
    @IBOutlet var connectionButtonOutlet: UIButton!
    @IBOutlet var restartButtonOutlet: UIButton!
    @IBOutlet var plantName: UILabel!
    @IBOutlet var plantDescription: UILabel!
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantImage.image = imageFromUser
        plantName.text = plantFound
        
       
    }
    
    override func viewWillLayoutSubviews() {
        self.plantImage.layer.cornerRadius = self.plantImage.frame.size.width / 2;
        self.plantImage.clipsToBounds = true
        self.plantImage.layoutIfNeeded()
    }

    // MARK: - Set Up


    // MARK: - IBActions
    @IBAction func toConnectionPage(_ sender: UIButton) {
    }
    @IBAction func restartCapture(_ sender: UIButton) {
    }
    

    // MARK: - Navigation


    // MARK: - Network Manager calls
    

}

// MARK: - Extensions

