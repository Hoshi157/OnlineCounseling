//
//  LoginSelectionViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/19.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import Firebase
import RealmSwift

//　ウォークスルー終了画面
class LoginSelectionViewController: UIViewController {
    
    private let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private let alert = AlertController()
    private var realm: Realm!
    
    lazy var accountCreateButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.setTitle("アカウント作成", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(accountCreateTransition), for: .touchUpInside)
        return button
    }()
    
    lazy var loginLessButton: MDCRaisedButton = {
       let button = MDCRaisedButton()
        button.setTitle("ログインせずに始める", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setBorderWidth(1, for: .normal)
        button.setBorderColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(loginLessTransition), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(accountCreateButton)
        view.addSubview(loginLessButton)
        
        accountCreateButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(84)
            make.right.equalTo(self.view).offset(-84)
            make.centerY.equalToSuperview().offset(100)
        }
        
        loginLessButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(84)
            make.right.equalTo(self.view).offset(-84)
            make.top.equalTo(accountCreateButton.snp.bottom).offset(30)
        }
        
        signinAnonymoous(completion: { (uid) in
            self.uidUpdataToLoacldata(uid: uid)
        })

        // Do any additional setup after loading the view.
    }
    
    @objc func accountCreateTransition() {
        let accountCreateVC = self.storyBoard.instantiateViewController(withIdentifier: "accountCreateVC") as! AccountCreateViewController
        let navi = UINavigationController(rootViewController: accountCreateVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
    @objc func loginLessTransition() {
        let tabbarVC = self.storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
        tabbarVC.modalPresentationStyle = .fullScreen
        present(tabbarVC, animated: true)
    }
    
    // 匿名認証
    func signinAnonymoous(completion: @escaping (_ uid: String?) -> Void) {
    Auth.auth().signInAnonymously() { (authResult, error) in
        if (error != nil) {
            print(error!.localizedDescription, "error")
            self.alert.okAlert(title: "エラーが発生しました", message: "ネットワークに繋いだ状態で操作してください", currentController: self)
        }
        guard let user = authResult?.user else {
            completion(nil)
            return
        }
        // uidを取得
        print(user.uid, "user.uid")
        completion(user.uid)
    }
    }
    // uidをRealmへ保存
    func uidUpdataToLoacldata(uid: String?) {
        do {
            guard let _uid = uid else { return }
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                user.uid = _uid
            }
        }catch {
            print(error.localizedDescription, "uid nil")
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
