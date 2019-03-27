//
//  UIViewController+Navigation.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showLoginView() {
        if let _ = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            let loginViewStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
            if let loginViewController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
