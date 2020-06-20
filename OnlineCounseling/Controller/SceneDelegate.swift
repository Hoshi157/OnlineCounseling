//
//  SceneDelegate.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var realm: Realm!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // 起動時画面変更
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last
            print(user?.uid ?? "nil", "user.uid")
            if (user != nil) {
                if (user!.loginFlg) {
                    let tabbarVC = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
                    window.rootViewController = tabbarVC
                    self.window = window
                    window.makeKeyAndVisible()
                }else {
                    let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
                    window.rootViewController = rootNavi
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }else {
                let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
                window.rootViewController = rootNavi
                self.window = window
                window.makeKeyAndVisible()
            }
        }catch {
            print(error.localizedDescription, "error Realm")
            let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
            window.rootViewController = rootNavi
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        addToLocaldata()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // まずはUser情報をrealmへ保存(開始時一度のみ)
    func addToLocaldata() {
        do {
            realm = try Realm()
            print(realm.objects(User.self).last ?? "nil", "User data")
            if (realm.objects(User.self).last == nil) {
                let myUser = User()
                try realm.write {
                    realm.add(myUser)
                    print(realm.objects(User.self), "realmの個数確認")
                }
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
}
