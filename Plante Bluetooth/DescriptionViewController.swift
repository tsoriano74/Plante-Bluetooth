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
        
        connectionButtonOutlet.layer.cornerRadius = 20
        plantImage.image = imageFromUser
        plantName.text = plantFound
        plantDescription.text = plantInfos(PlantName: plantFound)
        
       
    }
    
    
    
    override func viewWillLayoutSubviews() {
        self.plantImage.layer.cornerRadius = self.plantImage.frame.size.width / 2;
        self.plantImage.clipsToBounds = true
        self.plantImage.layoutIfNeeded()
    }

    // MARK: - Set Up
    private func plantInfos(PlantName: String) -> String {
        if PlantName == "Dypsis lutescens"{
            return "De la famille des Arecacées, jusqu'à une hauteur de 1,5 à 2,5m de hauteur, nécessite une bonne lumière. L'arrosage est nécessaire sous 2 à 3 jours, représentant un taux d'humidité de 30 %"
        } else if PlantName == "Aloe vera" {
            return "De la famille des Aloeacées, jusqu'à une hauteur de 0,5 à 1m de hauteur, nécessite une bonne lumière. L'arrosage est nécessaire 1 fois par semaine, représentant un taux d'humidité de 10 %"
        }
        return ""
    }

    // MARK: - IBActions
    @IBAction func toConnectionPage(_ sender: UIButton) {
    }
    @IBAction func restartCapture(_ sender: UIButton) {
    }
    

    // MARK: - Navigation


    // MARK: - Network Manager calls
    

}

// MARK: - Extensions

