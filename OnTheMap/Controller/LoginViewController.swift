//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Abdullah alammar on 28/05/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    func alert(title: String , message: String ){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
            return
        }))
        
        self.present(alert, animated: true)
        
    }
        
    
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func login(_ sender: UIButton) {
        updateUI(processing: true)
        
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces),
        let password=passwordField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty , !password.isEmpty
        else {
            
        alert(title: "Warning"  , message : "Email or password should not be empty" )
           updateUI(processing: false)
            
            return
        }
        
        UdacityAPI.PostSession(with: email, password: password) {
            (result, error) in
            
            if let error = error {
                self.alert(title: "ERROR"  , message : error.localizedDescription )
                 self.updateUI(processing: false)
                return
            }
            
            if let error = result?["error"] as? String {
                 self.alert(title: "ERROR"  , message : error )
                 self.updateUI(processing: false)
                return
                
                
            }
            
            if let session = result?["session"] as? [String:Any], let sessionId = session["id"] as? String {
                
                print(sessionId)
                UdacityAPI.deleteSession {
                     (error) in
                    
                    if let error = error {
                        self.alert(title: "ERROR"  , message : error.localizedDescription )
                        self.updateUI(processing: false)
                        return
                    }
                    self.updateUI(processing: false)
                    DispatchQueue.main.async {
                        
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.performSegue(withIdentifier: "showTapVC", sender: self)
                        
                    }
                    
                    
                    
                    
                }
                
                
            }
            
            
            
              self.updateUI(processing: false)
            
        }
        
    }
    
    
    func updateUI(processing : Bool) {
        
        DispatchQueue.main.async {
            self.emailField.isUserInteractionEnabled = !processing
            self.passwordField.isUserInteractionEnabled = !processing
            self.loginBtn.isEnabled = !processing
        }
    }
    
}
