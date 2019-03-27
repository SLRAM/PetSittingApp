//
//  UIViewController+Alert.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func confirmDeletionActionSheet(handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Deleting this activity will erase it permanently", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handler)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    public func showActionSheet(title: String?, message: String?, actionTitles: [String], handlers: [((UIAlertAction) -> Void)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, actionTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: actionTitle, style: .default, handler: handlers[index])
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

