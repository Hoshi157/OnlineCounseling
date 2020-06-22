//
//  TabbarController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class TabbarController: UITabBarController {
    
    private let usersDB = Firestore.firestore().collection("users")
    private var realm: Realm!
    
    var ViewControllers = [UIViewController]()
    
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
        
        let resevationVC = self.storyboard?.instantiateViewController(withIdentifier: "ResevationVC") as! ResevationViewController
        resevationVC.tabBarItem.title = "カウンセリング予約"
        resevationVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-予約-25")
        ViewControllers.append(resevationVC)
        
        let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryViewController
        historyVC.tabBarItem.title = "履歴"
        historyVC.tabBarItem.image = #imageLiteral(resourceName: "icons8-複数行テキスト-25")
        ViewControllers.append(historyVC)
        
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
        resevationVC.sidemenuDelegate = self
        messageHistoryVC.sidemenuDelegate = self
        
        sidemenuVC.delegate = self
        sidemenuVC.startPanGestureRecognizing()
        
        UpdataLoginstateToLocaldata {
            let uid = self.getUid()
            self.UpdataLoginstateClouddata(uid: uid)
        }
    }
    
    func showSidemenu(contentAvailabilty: Bool = true, animated: Bool) {
        
        if isShowSidemenu {return}
        sidemenuVC.beginAppearanceTransition(true, animated: true)
        sidemenuVC.view.autoresizingMask = .flexibleHeight
        sidemenuVC.view.frame = self.view.bounds
        view.addSubview(sidemenuVC.view)
        addChild(sidemenuVC)
        sidemenuVC.didMove(toParent: self)
        sidemenuVC.endAppearanceTransition()
        
        if contentAvailabilty {
            sidemenuVC.showContentView(animated: animated)
        }
    }
    
    func hideSideMenu(animated: Bool) {
        if !isShowSidemenu {return}
        sidemenuVC.hideContentView(animated: animated, completion: { (_) in
            self.sidemenuVC.view.removeFromSuperview()
            self.sidemenuVC.removeFromParent()
            self.sidemenuVC.willMove(toParent: nil)
        })
    }
    
    // Realmにログイン状態を更新
    func UpdataLoginstateToLocaldata(completion: () -> Void) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            if (user.loginFlg == false) {
            try realm.write {
                user.loginFlg = true
                completion()
            }
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    // Firebaseにログイン状態を更新
    func UpdataLoginstateClouddata(uid: String?) {
        guard let _uid = uid else { return }
        let post = ["loginFlg": true]
        usersDB.document(_uid).updateData(post)
    }
    // uidを取得
    func getUid() -> String? {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let uid = user.uid
            return uid
        }catch {
            print(error.localizedDescription, "uid nil")
            return nil
        }
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
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animeted: Bool) {
        showSidemenu(contentAvailabilty: contentAvailability, animated: animeted)
    }
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animeted: Bool) {
        hideSideMenu(animated: animeted)
    }
    func sidemenuViewcontroller(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSideMenu(animated: true)
    }
}
