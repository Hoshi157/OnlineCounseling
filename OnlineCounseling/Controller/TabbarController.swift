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
    
    lazy var HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
    
    private let sidemenuVC = SidemenuViewController()
    private var isShowSidemenu: Bool {
        return sidemenuVC.parent == self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        homeVC.tabBarItem.title = "ホーム"
        homeVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-ホーム-25")
        ViewControllers.append(homeVC)
        
        let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryViewController
        historyVC.tabBarItem.title = "履歴"
        historyVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-複数行テキスト-25")
        ViewControllers.append(historyVC)
        
        let timelineVC = self.storyboard?.instantiateViewController(withIdentifier: "TimelineVC") as! TimelineViewController
        timelineVC.tabBarItem.title = "タイムライン"
        timelineVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-タスク計画-25")
        ViewControllers.append(timelineVC)
        
        let messageHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageHistoryVC") as! MessageHistoryViewController
        messageHistoryVC.tabBarItem.title = "メッセージ"
        messageHistoryVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-chat-bubble-25")
        ViewControllers.append(messageHistoryVC)
        
        self.ViewControllers = ViewControllers.map{ (UINavigationController(rootViewController: $0)) }
        setViewControllers(ViewControllers, animated: false)
        
        self.tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tabBar.tintColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        
        homeVC.sidemenuDelegate = self
        historyVC.sidemenuDelegate = self
        timelineVC.sidemenuDelegate = self
        messageHistoryVC.sidemenuDelegate = self
        
        sidemenuVC.delegate = self
        sidemenuVC.startPanGestureRecognizing()
    }
    
    func showSidemenu(contentAvailabilty: Bool = true, animated: Bool, currentViewController: UIViewController) {
        
        if isShowSidemenu {return}
        
        addChild(sidemenuVC)
        sidemenuVC.view.autoresizingMask = .flexibleHeight
        sidemenuVC.view.frame = self.view.bounds
        view.insertSubview(sidemenuVC.view, aboveSubview: currentViewController.view)
        sidemenuVC.didMove(toParent: self)
        
        if contentAvailabilty {
            sidemenuVC.showContentView(animated: animated)
        }
    }
    
    func hideSideMenu(animated: Bool) {
        if !isShowSidemenu {return}
        
        sidemenuVC.hideContentView(animated: animated, completion: { (_) in
            self.sidemenuVC.willMove(toParent: nil)
            self.sidemenuVC.removeFromParent()
            self.sidemenuVC.view.removeFromSuperview()
        })
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

extension TabbarController: SidemenuViewControllerDelegate {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController {
        return self
    }
    func shouldPresentSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool {
        return true
    }
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animeted: Bool, currentViewController: UIViewController) {
        showSidemenu(contentAvailabilty: contentAvailability, animated: animeted, currentViewController: currentViewController)
    }
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animeted: Bool) {
        hideSideMenu(animated: animeted)
    }
    func sidemenuViewcontroller(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSideMenu(animated: true)
    }
}
