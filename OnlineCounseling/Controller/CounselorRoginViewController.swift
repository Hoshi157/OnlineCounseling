//
//  CounselorRoginViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/07.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import Firebase
import RealmSwift
// カウンセラーログイン画面
class CounselorRoginViewController: UIViewController {
    
    private var realm: Realm!
    private let usersDB = Firestore.firestore().collection("users")
    private var uid: String?
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "カウンセラーとしてログインされますか？"
        label.font = UIFont.systemFont(ofSize: 19)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    lazy var loginButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitle("ログイン", for: .normal)
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(explanationLabel)
        view.addSubview(loginButton)
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // navigationbar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backViewAction))
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        title = "カウンセラーログイン"
        
        explanationLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(explanationLabel.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        getUid()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // 自分のuidを取得
    func getUid() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            self.uid = user.uid
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    
    @objc func loginButtonAction() {
        updataLocaldata()
        // Firebaseを更新後、tableView更新
        updataClosere {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
            tabbarVC.loadView()
        }
        self.dismiss(animated: true, completion: nil)
    }
    // Realmのユーザー情報書き換え
    func updataLocaldata() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                user.type = "counselor"
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    // Firebaseの情報を書き換え
    func updataCloud() {
        let post = ["type": "counselor"]
        usersDB.document(self.uid!).updateData(post)
    }
    
    func updataClosere(completion: () -> Void) {
        updataLocaldata()
        updataCloud()
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
