//
//  ShareViewController.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 28/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ShareViewController: UIViewController {
    
    
    var locationCoordinate : CLLocationCoordinate2D!
    var locationName: String!
    
    @IBOutlet weak var linkField: UITextField!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    func alert(title: String , message: String ){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate!
        mapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 200, longitudinalMeters: 200)
        
        mapView.setRegion(viewRegion, animated: false)
        
        

    }
    
    @IBAction func submit(_ sender: Any) {
        
        UdacityAPI.Parse.postStudentLocation(link: linkField.text ?? "", locationCoordinate: locationCoordinate, locationName: locationName) {
            (error) in
            
            if let error = error {
                
                self.alert(title: "ERROR"  , message : error.localizedDescription )
              return
                
            }
            
            UserDefaults.standard.set(self.locationName , forKey : "studentLocation")
            
            DispatchQueue.main.async {
                self.parent!.dismiss(animated: true, completion: nil)
            }
            
            
            
        }
        
        
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    

}


extension  ShareViewController : MKMapViewDelegate {
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pinId"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            guard let toOpen = view.annotation?.subtitle! , let url = URL(string: toOpen) else {return }
            
            app.open(url, options: [:] , completionHandler: nil )
           
            
            
        }
    }
    
    
    
    
    
}
