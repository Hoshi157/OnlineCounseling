//
//  ViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ログインしているか認証(認証OK)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                return
            }
            print(user.uid, "user.uid")
            print(user.isAnonymous, "匿名ログインかどうか")
            print(auth.currentUser?.uid, "現在のユーザーuid")
        }
    }
}

