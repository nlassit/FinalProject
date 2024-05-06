//
//  InitialsViewController.swift
//  MemoryQuest
//
//  Created by Nathan Lassiter on 4/28/24.
//

import UIKit

class loginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(validateField), for: .editingChanged)
    }
    
    @objc private func validateField(){
        loginBtn.isEnabled = userNameTextField.text != ""
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            print("Username is required")
            return
        }
        NetworkServices.shared.login(userName: userName) {
            success in
            if success {
                self.gotoHomePage()
            } else {
                self.loginBtn.isEnabled = false
                print("invalid credentials")
            }
        }
    }
    
    func gotoHomePage(){
        loginBtn.isEnabled = true
    }
}
