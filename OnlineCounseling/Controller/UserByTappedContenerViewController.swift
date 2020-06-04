//
//  UserByTappedContenerViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Firebase
import RealmSwift

class UserByTappedContenerViewController: UIViewController {
    
    lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let collectionByTappedVC = CollectionCellTappedViewController()
    private let userDB = Firestore.firestore().collection("users")
    // タップしたUserデータのUid(presentした時に格納される)
    var userTapUid: String?
    var otherName: String? //プロフィール画面の名前
    private var uid: String?
    private var realm: Realm!
    private let alert = AlertController()
    
    private var childVC: CollectionCellTappedViewController {
        let child = self.children[0] as! CollectionCellTappedViewController
        return child
    }
    
    lazy var messageButton: MDCFloatingButton = {
       let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-chat-bubble-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(messageTransitionAction), for: .touchUpInside)
        return button
    }()
    
    lazy var calendarButton: MDCFloatingButton = {
       let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-カレンダー-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(calendarTransitionAction), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: MDCFloatingButton = {
        let button = MDCFloatingButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1).withAlphaComponent(0.8)
        let image = #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backViewAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 子Viewにした後でウィジット類をaddSubviewにているためボタンの方が上にくる
        addChild(collectionByTappedVC)
        view.addSubview(collectionByTappedVC.view)
        didMove(toParent: self)
        // ウィジット類
        view.addSubview(messageButton)
        view.addSubview(calendarButton)
        view.addSubview(dismissButton)
        
        messageButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.left.equalTo(self.view).offset(80)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        calendarButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.bottom.equalTo(messageButton)
            make.right.equalTo(self.view).offset(-80)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(20)
        }
        // Realmからuidを取得
        do {
            self.realm = try Realm()
            let user = realm.objects(User.self).last!
            self.uid = user.uid
        }catch {
            print("Realm error")
        }
        // お気に入りボタンをタップ可能にする
        childVC.bookmarkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookmarkImageTapped(_:))))
        childVC.bookmarkImageView.isUserInteractionEnabled = true
        
        getData()

        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    // カレンダーボタンをタップした時
    @objc func calendarTransitionAction() {
        let calendarVC = CalendarViewController()
        let naviController = UINavigationController(rootViewController: calendarVC)
        naviController.modalPresentationStyle = .fullScreen
        present(naviController, animated: true)
    }
    // メッセージボタンをタップした時
    @objc func messageTransitionAction() {
        // 自分と相手のuidと名前のnilチェック
        if (self.uid == nil && self.userTapUid == nil && self.otherName == nil) {
            self.alert.okAlert(title: "エラーが発生しました", message: "やり直してください", currentController: self)
            return
        }
        let messageVC = MessageViewController()
        messageVC.modalPresentationStyle = .fullScreen
        messageVC.otherUid = userTapUid // 相手のuidを渡す
        messageVC.otherName = otherName // 相手のNameを渡す
        // チャット歴があればルームナンバーを取得
        userDB.document(self.uid!).collection("alreadyMessage").whereField("roomId", isEqualTo: self.userTapUid!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error, "messageButton error")
            }else {
                for document in querySnapshot!.documents {
                    // 相手のuidがあればメッセージVCにRoomNumberを渡しbreak
                    let targetRoomNumber = document.data()["roomId"]
                    messageVC.alreadyRoomNumber = targetRoomNumber as? String
                    break
                }
            }
        }
        self.present(messageVC, animated: true)
        
    }
    // user情報を取得
    func getData() {
        if let cellUid = self.userTapUid {
            userDB.document(cellUid).getDocument { document, error in
                guard let data = document?.data() else {
                    return
                }
                // データの参照
                let name = data["name"] as! String
                let jobs = data["jobs"] as! String
                let gender = data["gender"] as! String
                let singleword = data["singlewordText"] as! String
                let selfinfo = data["selfintroText"] as! String
                // ここからはtableviewのデータ
                let birthday = data["birthday"] as! Timestamp
                let birthdayDate = birthday.dateValue()  // Date型にキャストしてから表示
                let area = data["area"] as! String
                let hobby = data["hobby"] as! String
                let medecalhistory = data["medicalhistoryText"] as! String
                // データをchildVCへ
                self.childVC.nameLabel.text = name
                self.childVC.jobsLabel.text = jobs
                if (gender == "男性") {
                    self.childVC.genderImageView.image = #imageLiteral(resourceName: "icons8-ユーザ男性-25-2").withRenderingMode(.alwaysTemplate)
                    self.childVC.genderImageView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                }else if (gender == "女性") {
                    self.childVC.genderImageView.image = #imageLiteral(resourceName: "icons8-ユーザー女性-25").withRenderingMode(.alwaysTemplate)
                    self.childVC.genderImageView.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }
                self.childVC.singleWordLabel.text = singleword
                self.childVC.selfIntroInputLabel.text = selfinfo
                // ここからはtableviewのデータ(dictionary型にて渡す)
                let profileDataDic: [String: Any] = ["生年月日": birthdayDate, "地域": area, "趣味": hobby, "既往歴": medecalhistory]
                self.childVC.profileDataDic = profileDataDic
            }
        }
    }
    
    // お気に入りボタンタップ時
       @objc func bookmarkImageTapped(_ sender: UITapGestureRecognizer) {
        if (self.uid != nil) {
            return
        }
        if (self.userTapUid != nil) {
            bookmarkDataPost()
        }
       }
    
    // お気に入りのデータをFirebaseにPostする処理
    func bookmarkDataPost() {
        self.userDB.document(self.userTapUid!).collection("bookmark").getDocuments { (querySnapshot, error) in
            if (error != nil) {
                print(error!.localizedDescription, "error")
                return
            }
            // 空だったらbookmarkに追加(この処理がないとbookmarkコレクションが作成されない)
            if (querySnapshot!.documents.isEmpty) {
                self.userDB.document(self.userTapUid!).collection("bookmark").addDocument(data: [self.uid!: self.uid!])
                self.bookmarkLocaldataAdd()
                self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
            for document in querySnapshot!.documents {
                // 自分のuidがあれば削除
                if (document.data()[self.uid!] != nil) {
                    let userDocumentid = document.documentID
                    self.userDB.document(self.userTapUid!).collection("bookmark").document(userDocumentid).delete()
                    self.bookmarkLocaldataDelete()
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    break
                }else {
                    // なければ追加
                    self.userDB.document(self.userTapUid!).collection("bookmark").addDocument(data: [self.uid!: self.uid!])
                    self.bookmarkLocaldataAdd()
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    break
                }
            }
                
        }
    }
    // Realmにお気に入りデータを追加
    func bookmarkLocaldataAdd() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let bookmarkHistory = BookmarkHistory(value: ["otherUid": userTapUid!, "otherName": otherName!])
            try realm.write {
                user.bookmarks.append(bookmarkHistory)
            }
        }catch {
            print("error Realm")
        }
    }
    // Realmのお気に入りを削除
    func bookmarkLocaldataDelete() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                for (index, bookmark) in user.bookmarks.enumerated() {
                    if (bookmark.otherUid == self.userTapUid) {
                        user.bookmarks.remove(at: index)
                    }
                }
            }
        }catch {
            print("error Realm")
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
