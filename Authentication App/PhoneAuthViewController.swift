//
//  PhoneAuthViewController.swift
//  Authentication App
//
//  Created by Mustafa on 13/04/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class PhoneAuthViewController: UIViewController {
    
    @IBOutlet weak var txt_phoneNum: UITextField!
    @IBOutlet weak var txt_OTP: UITextField!
    
    @IBOutlet weak var currentStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_OTP.isHidden = true
        currentStatus.text = "No User Signed In"
        // Do any additional setup after loading the view.
    }
    
    var currentUser:String = ""
    
    var verification_id:String? = nil
    
    @IBAction func submit_btn(_ sender: UIButton) {
        if txt_OTP.isHidden {
            if !txt_phoneNum.text!.isEmpty{
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                PhoneAuthProvider.provider().verifyPhoneNumber(txt_phoneNum.text!, uiDelegate: nil) { (verificationID, error) in
                    if error != nil {
                        return
                    }else {
                        self.verification_id = verificationID
                        self.txt_OTP.isHidden = false
                    }
                }
            } else {
                print("Please Enter Your Phone Number")
            }
        } else {
            if verification_id != nil {
                if let otp = txt_OTP.text {
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_id!, verificationCode: otp)
                    Auth.auth().signIn(with: credential) { (authData, error) in
                        if error != nil {
                            print(error.debugDescription)
                        } else {
                            print("Authentication Success with - " + (authData?.user.phoneNumber ?? "No Phone Number") )
                            self.currentUser = authData?.user.phoneNumber ?? "No Number"
                            print(self.currentUser)
                            self.currentStatus.text = "YOU ARE LOGIN AS - \(self.currentUser)"
                            
                        }
                    }
                } else {
                    print("Error In Getting Verification ID")
                }
            }
        }
    }
}
