//
//  TextInputProfileViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class TextInputProfileViewController: UIViewController {
    
    var titleText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (titleText != nil) {
            self.title = titleText
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func backViewAction() {
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
