//
//  AccountTakeoverViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class AccountTakeoverViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableArray: [String] = ["メールアドレス", "パスワード", "パスワードの確認"]
    // cellを取得するためのインデックス
    private var tableIndexPath: IndexPath!
    private let alert = AlertController()
    private var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewButtonAction))
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomAccountTakeOverTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTakeoverCell")
        tableView.rowHeight = 50
        
        // Do any additional setup after loading the view.
    }
    // viewタップでキーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
        tabbarController.modalPresentationStyle = .fullScreen
        self.present(tabbarController, animated: true)
    }
    
    @IBAction func dataCompleteButtonAction(_ sender: Any) {
        // tableViewのCellを取得
        let mailCell = self.tableView.cellForRow(at: [0,0]) as! CustomAccountTakeOverTableViewCell
        let passwordCell = self.tableView.cellForRow(at: [0,1]) as! CustomAccountTakeOverTableViewCell
        let confirmationPassCell = self.tableView.cellForRow(at: [0,1]) as! CustomAccountTakeOverTableViewCell
        // 匿名ログインから永久アカウントへ移行する
        if let adress = mailCell.textField.text, let password = passwordCell.textField.text, let confimationPass = confirmationPassCell.textField.text {
            // パスワード欄と確認用パスワードの一致確認
            if (password != confimationPass) {
                print(password, "pass")
                print(confimationPass, "confimation")
                alert.okAlert(title: "パスワードが正しくありません", message: "パスワードと確認用パスワードが一致しませんでした", currentController: self)
                return
            }
            // 入力されているか確認
            if (adress.isEmpty || password.isEmpty || confimationPass.isEmpty) {
                alert.okAlert(title: "入力されていません", message: "アドレス、パスワードを入力してください", currentController: self)
                return
            }
            // メールアドレスプロバイダに取得させる
            let credential = EmailAuthProvider.credential(withEmail: adress, password: password)
            let user = Auth.auth().currentUser
            // ログインユーザーとメールアドレスを紐付け
            user?.link(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                guard let user = authResult?.user else {
                    return
                }
                print(user.isAnonymous, "永久アカウントになればfalse")
                // 永久アカウントになればセグエ
                if !(user.isAnonymous) {
                    self.updataToAccountTakeoverFlg()
                    let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
                    tabbarController.modalPresentationStyle = .fullScreen
                    self.present(tabbarController, animated: true)
                }else {
                    self.alert.okAlert(title: "エラー", message: "メール認証によるアカウント認証はできませんでした", currentController: self)
                    return
                }
            }
            
        }
    }
    // 戻るボタン
    @objc func backViewButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    // アドレス、パスワードの登録したかを更新
    func updataToAccountTakeoverFlg() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                user.accountTakeoverFlg = true
            }
        }catch {
            print(error.localizedDescription, "error Realm")
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

extension AccountTakeoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTakeoverCell", for: indexPath) as! CustomAccountTakeOverTableViewCell
        // インデックスを格納
        self.tableIndexPath = indexPath
        let text = tableArray[indexPath.row]
        cell.textField.placeholder = text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
