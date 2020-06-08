//
//  LoginViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let tableviewArray: [String] = ["メールアドレス", "パスワード", "パスワードの確認"]
    private let alert = AlertController()
    private let usersDB = Firestore.firestore().collection("users")
    private var realm: Realm!
    
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
            // 以前ログインしたユーザーをログインさせる
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
                
                self.localdataRestorationFromCloud(uid: user.uid, completion: { () in
                    let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
                    tabbarController.modalPresentationStyle = .fullScreen
                    self.present(tabbarController, animated: true)
                })
            }
        }
    }
    
    
    // FirebaseからRealmにデータ復元
    func localdataRestorationFromCloud(uid: String, completion: () -> Void) {
        usersDB.document(uid).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription, "error firebase")
                return;
            }else {
                guard let document = document else { return}
                guard let data = document.data() else { return}
                let uid = document.documentID
                let name = data["name"] as! String
                let birthdayTimestamp = data["birthday"] as! Timestamp
                let birthday = birthdayTimestamp.dateValue()
                let type = data["type"] as! String
                let area = data["area"] as! String
                let gender = data["gender"] as! String
                let hobby = data["hobby"] as! String
                let jobs = data["jobs"] as! String
                let medicalhistory = data["medicalhistoryText"] as! String
                let selfIntro = data["selfintroText"] as! String
                let singleWord = data["singlewordText"] as! String
                self.localdataSave(uid: uid, name: name, birthday: birthday, type: type, area: area, gender: gender, hobby: hobby, jobs: jobs, medicalhistory: medicalhistory, selfintro: selfIntro, singleword: singleWord)
            }
        }
        completion()
    }
    
    // Realmに書き込み
    func localdataSave(uid: String, name: String, birthday: Date, type: String, area: String, gender: String, hobby: String, jobs: String, medicalhistory: String, selfintro: String, singleword: String) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                user.uid = uid
                user.name = name
                user.birthdayDate = birthday
                user.type = type
                user.area = area
                user.gender = gender
                user.hobby = hobby
                user.jobs = jobs
                user.medicalhistoryText = medicalhistory
                user.selfintroText = selfintro
                user.singlewordText = singleword
                getBookmarkdataFromCloud(myUid: uid, completion:{ (uid, name) in
                    let bookmark = BookmarkHistory(value: ["otherUid": uid, "otherName": name])
                    user.bookmarks.append(bookmark)
                })
                getMessagedataFromCloud(myUid: uid, completion: { (uid, name, roomId, lasttext) in
                    let message = BookmarkHistory(value: ["otherUid": uid, "otherName": name, "otherRoomNumber": roomId,  "lastText": lasttext])
                    user.bookmarks.append(message)
                })
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    
    // FirebaseからBookmark情報を取得
    func getBookmarkdataFromCloud(myUid: String, completion: @escaping (_ uid: String, _ name: String) -> Void) {
        usersDB.document(myUid).collection("bookmark").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription, "error bookmark firebase")
            }else {
                if (querySnapshot != nil) {
                    for document in querySnapshot!.documents {
                        let uid: String = document["uid"] as! String
                        let name: String = document["name"] as! String
                        completion(uid, name)
                    }
                }
            }
        }
    }
    // FirebaseからMessage情報を取得
    func getMessagedataFromCloud(myUid: String, completion: @escaping(_ uid: String, _ name: String, _ roomId: String, _ lastText: String) -> Void) {
        usersDB.document(myUid).collection("alreadyMessage").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription, "error")
            }else {
                if (querySnapshot != nil) {
                    for document in querySnapshot!.documents {
                        let uid = document["uid"] as! String
                        let name = document["name"] as! String
                        let roomId = document["roomId"] as! String
                        let lasttext = document["lastText"] as! String
                        completion(uid, name, roomId, lasttext)
                    }
                }
            }
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
