//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 31/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    
    let cellId = "cellId"
    
    var studentsLocations: [StudentLocation]! {
        
        return Global.shared.studentsLocations
    }

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
            
            print("studentsLocations nill")
        }
        else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    
    @IBAction func reloadStudentsLocations(_ sender: Any) {
        
        
        UdacityAPI.Parse.getStudentsLocations { (_ , error) in
            
            if let error = error { self.alert(title: "ERROR"  , message : error.localizedDescription )
                
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("hellllllllo")
            }
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func postPin(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            
            let alert = UIAlertController(title : "sdsdsddsds", message : nil , preferredStyle : .alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: {
                (action) in
                self.performSegue(withIdentifier: "listToNewLocation", sender: self)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else {
            
            self.performSegue(withIdentifier: "listToNewLocation", sender: self)
        }
        
        
        
        
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("number of rows : ", studentsLocations?.count ?? 0 )
        return studentsLocations?.count ?? 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
        
        


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentsLocations[indexPath.row]
        
        let app = UIApplication.shared
        
        guard let toOpen = studentLocation.mediaURL , let url = URL(string: toOpen) else {return }
        
        app.open(url, options: [:] , completionHandler: nil )
        
    
    }
    

}
