//
//  TabbarController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    var ViewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeVC: UINavigationController = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeViewController)
        homeVC.tabBarItem.title = "ホーム"
        ViewControllers.append(homeVC)
        
        let historuVC: UINavigationController = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(identifier: "HistoryVC") as! HistoryViewController)
        historuVC.tabBarItem.title = "履歴"
        ViewControllers.append(historuVC)
        
        let timelineVC: UINavigationController = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(identifier: "TimelineVC") as! TimelineViewController)
        timelineVC.tabBarItem.title = "タイムライン"
        ViewControllers.append(timelineVC)
        
        let messageHistoryVC: UINavigationController = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(identifier: "MessageHistoryVC") as! MessageHistoryViewController)
        messageHistoryVC.tabBarItem.title = "メッセージ"
        ViewControllers.append(messageHistoryVC)
        
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
