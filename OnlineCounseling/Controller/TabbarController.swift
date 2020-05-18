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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        homeVC.tabBarItem.title = "ホーム"
        ViewControllers.append(homeVC)
        
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryViewController
        historyVC.tabBarItem.title = "履歴"
        ViewControllers.append(historyVC)
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "TimelineVC") as! TimelineViewController
        timelineVC.tabBarItem.title = "タイムライン"
        ViewControllers.append(timelineVC)
        
        let messageHistoryVC = storyboard.instantiateViewController(withIdentifier: "MessageHistoryVC") as! MessageHistoryViewController
        messageHistoryVC.tabBarItem.title = "メッセージ"
        ViewControllers.append(messageHistoryVC)
        
        self.ViewControllers = ViewControllers.map{ (UINavigationController(rootViewController: $0)) }
        setViewControllers(ViewControllers, animated: false)
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
