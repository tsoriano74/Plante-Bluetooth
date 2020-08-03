//
//  StartViewController.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 02.08.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  

  // MARK: - Properties
    let url = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    var userImage = UIImage()
    var plantResult = String()

  // MARK: - IBOutlets
    @IBOutlet var startActionOutlet: UIButton!
    

  // MARK: - Life Cycle
    override func viewDidLoad() {
          super.viewDidLoad()
        startActionOutlet.layer.cornerRadius = 20
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
      }
      

  // MARK: - Set Up
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            userImage = image
            print("IMAGE WELL RECEIVED")
            guard let ciimage = CIImage(image: image) else {
                fatalError("Cannot convert to ciimage")
            }
            detect(image: ciimage)
        }
       
        imagePicker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "toPlantResults", sender: self)
        })
    }
    
    func detect(image:CIImage){
        guard let model = try? VNCoreMLModel(for: Plant_Classifier_1().model) else {
            fatalError("loading model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("process failed")
            }
            if let firstResult = results.first {
                self.plantResult = firstResult.identifier
                print(firstResult.identifier)
                self.requestInfo(plantName: firstResult.identifier)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try? handler.perform([request])
        } catch {
            print(error)
        }
        
    }

  // MARK: - IBActions
    @IBAction func startAction(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    

  // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? DescriptionViewController
        destinationVC?.imageFromUser = userImage
        destinationVC?.plantFound = plantResult
    }

  // MARK: - Network Manager calls
    func requestInfo(plantName: String){
        let parameters : [String:String] = ["format":"json", "action":"query", "prop":"extracts", "exintro":"","explaintext":"", "titles":plantName, "indexpageids":"", "redirects":"1"]
        Alamofire.request(url, method: .get, parameters:parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print(response)
            }
        }
    }
   

}

// MARK: - Extensions

