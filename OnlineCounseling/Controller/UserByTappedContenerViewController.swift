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
    
    lazy var counselingButton: MDCFloatingButton = {
        let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-ビデオ通話-25").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(counselingTransitionAction), for: .touchUpInside)
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
        view.addSubview(counselingButton)
        view.addSubview(dismissButton)
        
        messageButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.left.equalTo(self.view).offset(50)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        calendarButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.bottom.equalTo(messageButton)
            make.centerX.equalToSuperview()
        }
        
        counselingButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.bottom.equalTo(messageButton)
            make.right.equalTo(self.view).offset(-50)
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
        // 相手のuidをアンラップ
        if let otherUid = userTapUid {
            self.bookmarkStateRetention(targetId: otherUid)
            // Firebaseから情報を取得する
            getData()
            // 画像を表示する
            let filePath = fileInDocumentsDirectory(filename: otherUid)
            let image = loadImageFromPath(path: filePath)
            DispatchQueue.main.async {
                if (image != nil) {
                    self.childVC.avaterImageView.image = image
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    // カレンダーボタンをタップした時
    @objc func calendarTransitionAction() {
        let calendarVC = CalendarViewController()
        calendarVC.otherUid = userTapUid
        calendarVC.otherName = otherName
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
        messageVC.otherUid = userTapUid // 相手のuidを渡す
        messageVC.otherName = otherName // 相手のNameを渡す
        // チャット歴があればルームナンバーを取得(Realmから)
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                for message in user.messages {
                    if (message.otherUid == self.userTapUid) {
                        messageVC.alreadyRoomNumber = message.otherRoomNumber
                    }
                }
            }
        }catch {
            print("errorMessageTap Realm")
        }
        
        let navi = UINavigationController(rootViewController: messageVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
        
    }
    // カウンセリングボタンをタップした時
    @objc func counselingTransitionAction() {
        let connectVC = ConnectViewController()
        connectVC.otherName = self.otherName
        connectVC.otherUid = self.userTapUid
        let navi = UINavigationController(rootViewController: connectVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
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
                if (gender == "男") {
                    self.childVC.genderImageView.image = #imageLiteral(resourceName: "icons8-ユーザ男性-25-2").withRenderingMode(.alwaysTemplate)
                    self.childVC.genderImageView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                }else if (gender == "女") {
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
    
    // お気に入りボタンタップ時(Realmで判断する事でレスポンスが早くなる)
    @objc func bookmarkImageTapped(_ sender: UITapGestureRecognizer) {
        if (self.uid == nil) {
            self.alert.okAlert(title: "エラーが発生しました", message: "もう一度やり直すか、アカウントを最初から作成してください", currentController: self)
            return
        }
        if (self.userTapUid != nil) {
            existenceLocaldataBookmark(targetId: self.userTapUid!, targetName: self.otherName!)
            existenceCloudataBookmark(targetId: self.userTapUid!, targetName: self.otherName!, myId: self.uid!)
        }
    }
    
    // Realmにお気に入り履歴があるか判別
    func existenceLocaldataBookmark(targetId: String, targetName: String) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                // lazy.filterはtargetIdを見つけた時点で処理を抜ける
                let targetBookmark: BookmarkHistory? = user.bookmarks.lazy.filter { $0.otherUid == targetId}.first
                if (targetBookmark != nil) { // お気に入り履歴あり(削除)
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    // 削除処理(enumeratedは配列の番号を付属させる)
                    for (index, bookmark) in user.bookmarks.enumerated() {
                        if (bookmark.otherUid == targetId) {
                            user.bookmarks.remove(at: index)
                        }
                    }
                }else { // お気に入り履歴なし(追加)
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    // 追加処理
                    let bookmarkHistory = BookmarkHistory(value: ["otherUid": targetId, "otherName": targetName])
                    user.bookmarks.append(bookmarkHistory)
                }
            }
        }catch {
            print("error Realm")
        }
    }
    // Firebaseのお気に入り履歴のデータを判別して追加か削除
    func existenceCloudataBookmark(targetId: String, targetName: String, myId: String) {
        self.userDB.document(myId).collection("bookmark").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription, "error")
            }else {
                let snapshot: QueryDocumentSnapshot? = querySnapshot?.documents.lazy.filter { $0.data()["uid"] as? String == targetId }.first
                // お気に入り履歴あり(削除)
                if (snapshot != nil) {
                    let userDocumentId: String = snapshot!.documentID
                    self.userDB.document(myId).collection("bookmark").document(userDocumentId).delete()
                }else { // お気に入り履歴なし(追加)
                    self.userDB.document(myId).collection("bookmark").addDocument(data: ["uid": targetId, "name": targetName])
                }
            }
        }
    }
    
    // 起動時にbookmarkしていたら色を変えとく
    func bookmarkStateRetention(targetId: String) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                let targetBookmark: BookmarkHistory? = user.bookmarks.lazy.filter { $0.otherUid == targetId}.first
                // お気に入り履歴にあったら色表示
                if (targetBookmark != nil) {
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                }else {
                    self.childVC.bookmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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

extension UserByTappedContenerViewController: imageSaveProtocol {}
