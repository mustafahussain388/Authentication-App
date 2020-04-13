//
//  ViewController.swift
//  Authentication App
//
//  Created by Mustafa on 13/04/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var newUSer:String = ""
    
    @IBOutlet weak var lb_login_Status: UILabel!
    
    @IBOutlet weak var btn_sign_out: UIButton!
    
    
    @IBAction func fbLoginPressed(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }else {
                    self.currentUserName()
                }
            
            })

        }
    }
    func currentUserName()  {
        if let currentUser = Auth.auth().currentUser {
            self.btn_sign_out.isHidden = false
            lb_login_Status.text = "YOU ARE LOGIN AS - " +  (currentUser.displayName ?? "DISPLAY NAME NOT FOUND")
        }
    }
    @IBAction func signOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.lb_login_Status.text = "Please login now"
            self.btn_sign_out.isHidden = true
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

