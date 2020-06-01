//
//  ViewController.swift
//  covidAI
//
//  Created by Parikshat Sawant on 5/17/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lblGuess: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var aboutCOVIDButton: UIButton!
    @IBOutlet weak var LearnButton: UIButton!
    
    @IBOutlet weak var TryAgainLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        lblGuess.numberOfLines = 2
        TryAgainLabel.numberOfLines = 2
        uploadButton.layer.cornerRadius = uploadButton.frame.size.width/2
        aboutCOVIDButton.layer.cornerRadius = aboutCOVIDButton.frame.size.width/2
        LearnButton.layer.cornerRadius = LearnButton.frame.size.width/2
    }
    
    @IBAction func learnAboutXRays(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "learn_vc") as! LearnViewController
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var COVIDsourceObservation : VNFeaturePrintObservation?
        var PneumoniasourceObservation : VNFeaturePrintObservation?
        var NORMALsourceObservation : VNFeaturePrintObservation?
        var imageObservation : VNFeaturePrintObservation?
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageObservation = featurePrintObservationForImage(image: pickedImage)
            COVIDsourceObservation = featurePrintObservationForImage(image: UIImage(named: "Image-4")!)
            PneumoniasourceObservation = featurePrintObservationForImage(image: UIImage(named: "Image-7")!)
            NORMALsourceObservation = featurePrintObservationForImage(image: UIImage(named: "Image-5")!)
            var COVIDdistance = Float(0)
            var Pneumoniadistance = Float(0)
            var NORMALdistance = Float(0)
            do {
                if let COVIDsourceObservation = COVIDsourceObservation {
                    try imageObservation?.computeDistance(&COVIDdistance, to: COVIDsourceObservation)
                }
                if let NORMALsourceObservation = NORMALsourceObservation {
                    try imageObservation?.computeDistance(&NORMALdistance, to: NORMALsourceObservation)
                }
                if let PneumoniasourceObservation = PneumoniasourceObservation {
                    try imageObservation?.computeDistance(&Pneumoniadistance, to: PneumoniasourceObservation)
                }
            } catch {
                print("Error Ocurred")
                
            }
            if (COVIDdistance < 21) || (Pneumoniadistance < 21) || (NORMALdistance < 21) {
                lblGuess.text = "Diagnosing..."
                imageView.contentMode = .scaleToFill
                imageView.image = pickedImage
                guard let model = try? VNCoreMLModel(for: NewMLModel3().model) else{
                    fatalError("Unexpected results")
                }
                let request = VNCoreMLRequest(model: model){[weak self] request, error in
                    guard let predictions = request.results as? [VNClassificationObservation],
                    let bestResult = predictions.first
                    else {
                        fatalError("Model Can't Load")
                    }
                    let secondResult = predictions[1]
                    DispatchQueue.main.async { [weak self] in
                        if (bestResult.confidence > 0.8) {
                        self?.lblGuess.text = "\(bestResult.identifier) with \(Int(bestResult.confidence * 100))% confidence"
                        self?.TryAgainLabel.text = "Wanna try again? Upload another image!"
                        } else {
                            self?.lblGuess.text = "\(bestResult.identifier) with \(Int(bestResult.confidence * 100))% confidence" + "\n" + "\(secondResult.identifier) with \(Int(secondResult.confidence * 100))% confidence"
                            self?.TryAgainLabel.text = "Wanna try again? Upload another image!"
                            
                        }
                    }
                    
                }
                guard let ciImage = CIImage(image: pickedImage)
                    else {
                        fatalError("Cannot read picked image")
                }
                
                let handler = VNImageRequestHandler(ciImage: ciImage)
                DispatchQueue.global().async {
                    do {
                        try handler.perform([request])
                        
                    } catch {
                        print(error)
                    }
                }
            } else {
                lblGuess.text = "Oops...we didn't recognize this as a valid image!"
                TryAgainLabel.text = "Upload a better image, or click the learn button for more examples!"
                TryAgainLabel.numberOfLines = 2
                imageView.image = pickedImage
            }
            picker.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
    func featurePrintObservationForImage(image: UIImage) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("VISION ERROR")
            return nil
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func didTapAboutButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "about_covid_vc") as! COVIDViewController
        present(vc, animated: true)
        
    }
}

