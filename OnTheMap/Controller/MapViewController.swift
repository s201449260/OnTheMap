//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 28/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var studentsLocations: [StudentLocation]! {
        
        return Global.shared.studentsLocations
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    @IBOutlet weak var postPinBtn: UIBarButtonItem!
    
    
    func alert(title: String , message: String ){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (studentsLocations == nil ){
            reloadStudentsLocations(self)
        }
        else {
            DispatchQueue.main.async {
                self.updateAnnotations()
            }
        }
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        
        UdacityAPI.deleteSession {
            (error) in
            
            if let error = error { self.alert(title: "ERROR"  , message : error.localizedDescription )
              
                return
            }
            
            DispatchQueue.main.async {
                
                self.dismiss(animated: true , completion : nil)
                
            }
            
        }

        
        
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
self.mapView.delegate = self
    }
    
    @IBAction func postPin(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            
            let alert = UIAlertController(title : "Do you want to overrite your old location ?", message : nil , preferredStyle : .alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: {
                (action) in
                self.performSegue(withIdentifier: "mapToNewLocation", sender: self)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else {
            
            self.performSegue(withIdentifier: "mapToNewLocation", sender: self)
        }
        
        
        
        
    }
    
    
    @IBAction func reloadStudentsLocations(_ sender: Any) {
        
        UdacityAPI.Parse.getStudentsLocations { (_ , error) in
            
            if let error = error { self.alert(title: "ERROR"  , message : error.localizedDescription )
                
                return
            }
            
            DispatchQueue.main.async {
                self.updateAnnotations()
            }
            
            }
        
        
        
    }
    
  

    func updateAnnotations() {
    
        var annotations  = [MKPointAnnotation]()
    for studentLocation in studentsLocations {
    
    let lat = CLLocationDegrees(studentLocation.latitude ?? 0 )
    let long = CLLocationDegrees(studentLocation.longitude ?? 0 )
    let coordinate  = CLLocationCoordinate2D(latitude: lat, longitude: long)
    let first  = studentLocation.firstName ?? ""
    let last  = studentLocation.lastName ?? ""
    let mediaURL = studentLocation.mediaURL ?? ""
   
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        if !mapView.annotations.contains(where: {$0.title == annotation.title} ) {
            
            annotations.append(annotation)
        }
//         annotations.append(annotation)
        
//    self.mapView.addAnnotations (annotations)
    
    }
        
        // When the array is complete, we add the annotations to the map.
        print("new annotations " , annotations.count)
        self.mapView.addAnnotations(annotations)
    
    }
    
    
}

extension MapViewController : MKMapViewDelegate {
    
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
//                app.openURL(URL(string: toOpen)!)
            
            
        }
    }
    
    
    
}
