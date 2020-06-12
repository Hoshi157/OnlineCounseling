//
//  AlertController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/23.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
// アラート
class AlertController {
    
    func okAlert(title: String, message: String, currentController: UIViewController, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        alertController.addAction(okAction)
        currentController.present(alertController, animated: true, completion: nil)
    }
    
    func popAlert(title: String, currentController: UIViewController, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        currentController.present(alertController, animated: true, completion: completionHandler)
    }
}
