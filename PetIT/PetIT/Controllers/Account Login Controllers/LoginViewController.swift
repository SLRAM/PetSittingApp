//
//  LoginViewController.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        authservice.authserviceExistingAccountDelegate = self
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else {
                return
        }
        authservice.signInExistingAccount(email: email, password: password)
    }
}

extension LoginViewController: AuthServiceExistingAccountDelegate {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Signin Error", message: error.localizedDescription)
    }
    
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.modalPresentationStyle = .overFullScreen
        present(mainTabBarController, animated: true)
    }
}
