//
//  MessageViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import RealmSwift

class MessageViewController: MessagesViewController {
    // Message
    private var Messages: [MockMessage] = []
    private var roomId: String?
    private var chatFlg: Bool? // 相手がいる場合、ture
    var otherUid: String? // 相手のuid
    var otherName: String? // 相手のName(チャット履歴としてRealmに保存する)
    var alreadyRoomNumber: String? // チャット歴がある場合のみ相手のroomNumber
    // Firestore
    private let DB = Firestore.firestore()
    private let usersDB = Firestore.firestore().collection("users")
    // Realm
    private var realm: Realm!
    private var uid: String?
    private var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(messagesCollectionView)
        // navigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backviewAction))
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        // タイトルの相手の名前を表示
        if (otherName != nil) {
            title = otherName
        }else {
            title = "チャット画面"
        }
        // MessageKitの設定
        let edgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        messagesCollectionView.contentInset = edgeInsets
        messagesCollectionView.scrollIndicatorInsets = edgeInsets
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
        if let layot = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layot.setMessageIncomingAvatarSize(.zero)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layot.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layot.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
        }
        chatFlg = false
        // Realmからデータ取り出す
        do {
            self.realm = try Realm()
            let user = realm.objects(User.self).last!
            self.uid = user.uid
            self.name = user.name
        }catch {
            print("Realm error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.reloadData()
        
        if self.alreadyRoomNumber != nil {
            // チャット履歴があれば
            print("チャット履歴あり")
            self.historyGetroom()
        }else{
            // チャット履歴がなければ
            self.getroom()
            print("チャット履歴なし")
        }
    }
    
    @objc func backviewAction() {
        dismiss(animated: true, completion: nil)
    }
    // 相手のuidのnilチエックと自分のuidと違うかどうか(チャット履歴なし①)
    func getroom() {
        if self.otherUid != nil && self.uid != self.otherUid {
            self.getNewRoomKey()
        }
    }
    // 新しいルームナンバーを取得(チャット履歴なし②)
    var count = 1
    func getNewRoomKey() {
        // firebaseのルームナンバーを更新
        Firestore.firestore().collection("roomKey").document("roomKeyNumber").getDocument {  (document, error) in
            if let document = document {
                let number = document.data()!["number"] as! Int
                self.count = number + 1
            }
            // ルームナンバーを更新
            Firestore.firestore().collection("roomKey").document("roomKeyNumber").setData(["number":self.count])
            // ここで取得
            self.roomId = String(self.count)
            self.UpdateEachInfo()
        }
    }
    // ここでチャット履歴を更新(チャット履歴なし③)
    func UpdateEachInfo() {
        // お互いのroomIdを合わせる
        usersDB.document(self.otherUid!).updateData(["inRoom":self.roomId!])
        usersDB.document(self.uid!).updateData(["inRoom":self.roomId!])
        // お互いのチャット履歴を追加(Firestore)
        usersDB.document(self.uid!).collection("alreadyMessage").addDocument(data: [self.otherUid!: self.roomId!])
        usersDB.document(self.otherUid!).collection("alreadyMessage").addDocument(data: [self.uid!:self.roomId!])
        //　お互いのチャット履歴を追加(Realm)
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let chateHistory = MessageHistory(value: ["otherUid": otherUid!, "otherName": otherName!, "otherRoomNumber": self.roomId!])
            try realm.write {
                user.messages.append(chateHistory)
            }
        }catch {
            print("error Realm")
        }
        self.getMessage()
    }
    // チャット開始(チャット履歴なし④)
    func getMessage() {
        self.chatFlg = true
        DB.collection("rooms").document(self.roomId!).collection("chate").addSnapshotListener { (querySnapshot,error) in
            if let error = error {
                print(error, "error")
            }else {
                // firebaseに追加されたデータをリッスン
                querySnapshot!.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chateDataOp = diff.document.data() as? Dictionary<String,String>
                        guard let chateData = chateDataOp else{ return }
                        // データを取得
                        let text = chateData["text"]
                        let from = chateData["from"]
                        let name = chateData["name"]
                        // データを追加
                        let message = MockMessage(messageId: "", sender: senderUser(senderId: from!, displayName: name!), sentDate: Date(), text: text!)
                        self.Messages.append(message)
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
                    }
                }
            }
        }
    }
    // nilチェックしルームナンバーを揃える(チャット履歴あり①)
    func historyGetroom() {
        if self.otherUid != nil && self.uid != self.otherUid {
            // 自分と相手のルームナンバーを同じにする
            usersDB.document(self.otherUid!).updateData(["inRoom":self.alreadyRoomNumber!])
            usersDB.document(self.uid!).updateData(["inRoom":self.alreadyRoomNumber!])
            self.alreadyRoomNumberGetMessage()
        }
    }
    // チャット開始(チャット履歴あり②)
    func alreadyRoomNumberGetMessage(){
        self.chatFlg = true
        // 追加されるたびイベント発火
        DB.collection("rooms").document(self.alreadyRoomNumber!).collection("chate").addSnapshotListener{ (querySnaoshot, eroor) in
            if let error = eroor {
                print(error, "error")
            }else {
                // firebaseに追加されたデータをリッスン
                querySnaoshot!.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chateDataOp = diff.document.data() as? Dictionary<String,String>
                        guard let chateData = chateDataOp else{ return }
                        // 変更されるたびにデータを取得する
                        let text = chateData["text"]
                        let from = chateData["from"]
                        let name = chateData["name"]
                        // データを追加する
                        let message = MockMessage(messageId: "", sender: senderUser(senderId: from!, displayName: name!), sentDate: Date(), text: text!)
                        self.Messages.append(message)
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
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

extension MessageViewController: MessagesDataSource {
    // 自分の情報
    func currentSender() -> SenderType {
        return senderUser(senderId: self.uid!, displayName: self.name!)
    }
    // メッセージ内容
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Messages[indexPath.section]
    }
    // メッセージの数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Messages.count
    }
}



extension MessageViewController: InputBarAccessoryViewDelegate {
    // テキストを入力してボタンを押した時
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if chatFlg == true {
            postData(text: text)
            localTextUpdata(targetId: self.otherUid!, text: text)
        }else{
            print("error")
        }
        inputBar.inputTextView.text = String()
    }
    // データをfirebaseにPostする
    func postData(text:String){
        let post = ["from": currentSender().senderId, "name": currentSender().displayName,"text": text]
        if self.roomId != nil { // チャット履歴がない場合,
            let chateDb = Firestore.firestore().collection("rooms").document(self.roomId!).collection("chate")
            chateDb.addDocument(data: post)
        }else{ // チャット履歴がある場合,
            let chateTargetDb = Firestore.firestore().collection("rooms").document(self.alreadyRoomNumber!).collection("chate")
            chateTargetDb.addDocument(data: post)
        }
    }
    // チャットの最後の文のみを保存(トークルームに表示する)
    func localTextUpdata(targetId: String, text: String) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                // 相手のuidがあるか判別
                let targetMessage: MessageHistory? = user.messages.lazy.filter { $0.otherUid == targetId}.first
                if (targetMessage != nil) {
                    // いたら文を更新
                    targetMessage!.lastText = text
                }
            }
        }catch {
            print("error Realm")
        }
    }
    // アバターを設定
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let filePath = self.fileInDocumentsDirectory(filename: self.uid!)
        let image = self.loadImageFromPath(path: filePath)
        if (image != nil) {
            let avater = Avatar(image: image, initials: currentSender().displayName)
            avatarView.set(avatar: avater)
        }
    }
}

extension MessageViewController:MessagesLayoutDelegate {
    // メッセージセルの文字をセルの間隔
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 0
    }
    // メッセージセル同士の間隔(top)
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    // メッセージセル同士の間隔(Bottom)
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}


extension MessageViewController:MessagesDisplayDelegate {
    // セルの色
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // セルのレイアウト
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}
// これもdelegateしないと表示されない
extension MessageViewController: MessageCellDelegate {}

extension MessageViewController: imageSaveProtocol {}
