//
//  NewPinViewController.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 28/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit
import CoreLocation


class NewPinViewController: UIViewController, UITextFieldDelegate {
    
    
    var locationCoordinate : CLLocationCoordinate2D!
    var locationName: String!
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var findButton: UIButton!
    
    func alert(title: String , message: String ){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
            return
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
            locationField.text = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "fromNewPinVCToShareVC" {
            
            
        let vc = segue.destination as! ShareViewController
    vc.locationCoordinate = locationCoordinate
    vc.locationName = locationName
            
            
            
        }
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateUI(processing : Bool){
    
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !processing
            self.findButton.isEnabled = !processing
            
            
        }
    
    }
    
    
    
    @IBAction func findButton(_ sender: UIButton) {
        updateUI(processing: true)
        
        guard let locationName = locationField.text?.trimmingCharacters(in: .whitespaces) , !locationName.isEmpty else {
            
            alert(title: "warning", message: "should not be empty")
            updateUI(processing: false)
            return
            
            
        }
        
        getCoordinateFrom(location : locationName ) {
            (locationCoordinate, error ) in
            if let error = error {
                
                self.alert(title: "warning", message: "try different city name")
                print(error)
                self.updateUI(processing: false)
            }
            self.activityIndicator.startAnimating()
 self.activityIndicator.isAnimating == true
            
            
            self.locationCoordinate = locationCoordinate
            self.locationName = locationName
            self.updateUI(processing: false)
            self.performSegue(withIdentifier: "fromNewPinVCToShareVC", sender: self)
        }
        
        
        
        
    }
    
    
    
    func getCoordinateFrom(location : String, completion : @escaping(_ coordinate: CLLocationCoordinate2D? , _ error : Error?) -> () ){
        
        CLGeocoder().geocodeAddressString(location){
            placemarks , error in completion(placemarks?.first?.location?.coordinate , error )
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true

    }
    

 
}
