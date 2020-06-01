//
//  LoginViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let tableviewArray: [String] = ["メールアドレス", "パスワード", "パスワードの確認"]
    private let alert = AlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomAccountTakeOverTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTakeoverCell")
        tableView.rowHeight = 50

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func backViewAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let mailCell = self.tableView.cellForRow(at: [0,0]) as! CustomAccountTakeOverTableViewCell
        let passwordCell = self.tableView.cellForRow(at: [0,1]) as! CustomAccountTakeOverTableViewCell
        let confirmationPassCell = self.tableView.cellForRow(at: [0,1]) as! CustomAccountTakeOverTableViewCell
        
        if let adress = mailCell.textField.text, let password = passwordCell.textField.text, let confimationPass = confirmationPassCell.textField.text {
        // パスワード欄と確認用パスワードの一致確認
        if (password != confimationPass) {
            alert.okAlert(title: "パスワードが正しくありません", message: "パスワードと確認用パスワードが一致しませんでした", currentController: self)
            return
        }
        // 入力されているか確認
        if (adress.isEmpty || password.isEmpty || confimationPass.isEmpty) {
            alert.okAlert(title: "入力されていません", message: "アドレス、パスワードを入力してください", currentController: self)
            return
        }
            // 以前ログインしたユーザーをログインさせる(ログイン成功後、Firebaseから自分の情報を引っ張ってくる　未実装)
            Auth.auth().signIn(withEmail: adress, password: password) { (authResult, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                    self.alert.okAlert(title: "ログインできません", message: "エラーが発生しログインできません", currentController: self)
                    return
                }
                guard let user = authResult?.user else {
                    return
                }
                print(user.uid, "user.uid")
                let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
                tabbarController.modalPresentationStyle = .fullScreen
                self.present(tabbarController, animated: true)
            }
        }
        let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
        tabbarController.modalPresentationStyle = .fullScreen
        self.present(tabbarController, animated: true)
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

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTakeoverCell", for: indexPath) as! CustomAccountTakeOverTableViewCell
        let text = tableviewArray[indexPath.row]
        cell.textField.placeholder = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
