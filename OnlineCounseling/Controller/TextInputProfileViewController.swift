//
//  TextInputProfileViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import RealmSwift

class TextInputProfileViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var titleText: String?
    private var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 推移してきたtitleを追加
        if (titleText != nil) {
            self.title = titleText
        }
        
        // TextviewへのData取り出し
        do {
        self.realm = try Realm()
        let user = self.realm.objects(User.self).last!
            switch (self.titleText) {
            case "名前":
                textView.text = user.name
            case "自己紹介":
                textView.text = user.selfintroText
            case "趣味":
                textView.text = user.hobby
            case "カウンセラーに伝えておきたい事":
                textView.text = user.singlewordText
            case "既往歴":
                textView.text = user.medicalhistoryText
            default:
                textView.text = ""
            }
        }catch {
            print("error")
        }
    }
    
    // Realmへの書き込み
    func addUser(text: String) {
        do {
            self.realm = try Realm()
            let user = realm.objects(User.self).last!
        try realm.write {
            switch (self.titleText) {
            case "名前":
                user.name = text
            case "自己紹介":
                user.selfintroText = text
            case "趣味":
                user.hobby = text
            case "カウンセラーに伝えておきたい事":
                user.singlewordText = text
            case "既往歴":
                user.medicalhistoryText = text
            default:
                print("eroor")
            }
        }
        }catch {
            print("error")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func backViewAction() {
        self.addUser(text: textView.text)
        navigationController?.popViewController(animated: true)
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
