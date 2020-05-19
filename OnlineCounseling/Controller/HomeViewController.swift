//
//  HomeViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.title = "ホーム"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25"), style: .plain, target: self, action: #selector(sidemenuButtonAction))
    }
    
    @objc func sidemenuButtonAction() {
        print("tap")
        tabbarVC.showSidemenu(animated: true)
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
