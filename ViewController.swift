//
//  ViewController.swift
//  camera
//
//  Created by USER on 12/9/18.
//  Copyright © 2018 USER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var mytext: UITextView!
    @IBAction func importImage(_ sender: UIButton) {
      let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated:true){
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageview.image = image
        }
        
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    func detect() {
        //get image from image view
        let myImage = CIImage(image: imageview.image!)!
        //set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile: true])
        if !faces!.isEmpty{
            for face in faces as! [CIFaceFeature] {
                let mouthShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                let isSmiling = "\nPerson is smiling: \(face.hasSmile)"
                var bothEyesShowing = "\nBoth eyes showing: true"
                if !face.hasRightEyePosition || !face.hasLeftEyePosition {
                    bothEyesShowing = "\nBoth eyes showing: false"
                }
                //degree of suspicion
                let array = ["Low", "Medium", "High", "Very high"]
                var suspectDegree = 0
                if !face.hasMouthPosition {
                    suspectDegree += 1
                }
                if !face.hasSmile {
                    suspectDegree += 1
                }
                if bothEyesShowing.contains("false") {
                    suspectDegree += 1
                }
                if face.faceAngle > 10 || face.faceAngle < -10 {
                    suspectDegree += 1
                }
                let suspectText = "\nSuspiciousness: \(array[suspectDegree])"
                mytext.text = "\(suspectText) \n\(mouthShowing) \(isSmiling) \(bothEyesShowing)"
            
            }
        }
        else {
            mytext.text = "No Face Detected"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detect()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

