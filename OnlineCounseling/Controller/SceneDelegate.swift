//
//  SceneDelegate.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var realm: Realm!
    private let usersDB = Firestore.firestore().collection("users")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // 起動時画面変更
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last
            print(user?.uid ?? "nil", "user.uid")
            // RealmのuidがあればTabbarVC(ログインしている)
            if (user?.uid != nil) {
                self.loginToCloud(myUid: user!.uid, completion: { (result) in
                    if (result) {
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
                        window.rootViewController = tabbarVC
                    }else {
                        let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
                        window.rootViewController = rootNavi
                    }
                })
            }else {
                // uidがなければrootNavi(ログインしていない)
                let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
                window.rootViewController = rootNavi
            }
        }catch {
            print("error")
            let rootNavi = storyboard.instantiateViewController(withIdentifier: "rootNavi")
            window.rootViewController = rootNavi
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
        
        self.addToLocaldata(completion: { () in
            self.getUidFromCloud()
        })
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // Firebaseからuidを取得して処理を実行
    func getUidFromCloud() {
        usersDB.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription, "firebase error")
            }else {
                for data in querySnapshot!.documents {
                    let uid = data.documentID
                    let judge = self.localdataSaveJudge(targetUid: uid)
                    if (judge) {
                        return;
                    }else {
                        self.loadImage(targetUid: uid, completionClosure: { (image) -> Void in
                            guard let image = image else { return}
                            let filePath = self.fileInDocumentsDirectory(filename: uid)
                            let saveJudge = self.saveImage(image: image, path: filePath)
                            if (saveJudge) {
                                self.toLocaldataSaveTheImagepath(targetUid: uid, path: filePath)
                            }
                        })
                    }
                }
            }
        }
    }
    // targetUidがRealmに保存されているか判定
    func localdataSaveJudge (targetUid: String) -> Bool {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let otherUser: OtherUser? = user.otherUsers.lazy.filter { $0.uid == targetUid}.first
            if (otherUser != nil) {
                return true
            }else {
                return false
            }
        }catch {
            print(error.localizedDescription, "error Realm")
            return false
        }
    }
    // Realmへ保存する
    func toLocaldataSaveTheImagepath (targetUid: String, path: String) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                let otherUser = OtherUser(value: ["uid": targetUid, "imagePath": path])
                user.otherUsers.append(otherUser)
            }
        }catch {
            print(error.localizedDescription, "Realm error")
        }
    }
    
    // まずはUser情報をrealmへ保存(開始時一度のみ)
    func addToLocaldata(completion: () -> Void) {
        do {
            realm = try Realm()
            print(realm.objects(User.self).last ?? "nil", "User data")
            if (realm.objects(User.self).last == nil) {
                let myUser = User()
                myUser.type = "user"
                try realm.write {
                    realm.add(myUser)
                    print(realm.objects(User.self), "realmの個数確認")
                    completion()
                }
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    
    func loginToCloud(myUid: String, completion: @escaping(_ result: Bool) -> Void) {
        usersDB.getDocuments { (qurySnapshot, error) in
            if let error = error {
                print(error.localizedDescription, "error Firebase")
                completion(false)
            }else {
                let data = qurySnapshot?.documents.lazy.filter{ $0.documentID == myUid}.first
                if (data != nil) {
                    completion(true)
                }else {
                    completion(false)
                }
            }
        }
    }
    
}

extension SceneDelegate: imageSaveProtocol {}
extension SceneDelegate: storageProtocol {}
