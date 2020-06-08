//
//  MessageViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

class MessageHistoryViewController: UIViewController {
    // サイドメニュー
    let sidemenuVC = SidemenuViewController()
    weak var sidemenuDelegate: SidemenuViewControllerDelegate?
    // Cellのデータ配列
    var talkrooms: [Talkroom] = []
    // Realm
    private var realm: Realm!
    private var token: NotificationToken!
    
    lazy var myTableview: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        return tableView
    }()
    
    private let topNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21)
        label.text = "メッセージを送受信する"
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let underNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "カウンセラーに直接メッセージを送れます。\nホーム画面のプロフィール画面からメッセージを\n送ってみましょう。"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        localDataGet()
        localdataObserve()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        self.title = "メッセージ"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25"), style: .plain, target: self, action: #selector(sidemenuButtonAction))
        
    }
    
    @objc func sidemenuButtonAction() {
        self.sidemenuDelegate?.sidemenuViewControllerDidRequestShowing(sidemenuVC, contentAvailability: true, animeted: true)
    }
    // Realmからメッセージ履歴データを取得する
    func localDataGet() {
        talkrooms = []
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                for message in user.messages {
                    let name = message.otherName
                    let uid = message.otherUid
                    let roomKey = message.otherRoomNumber
                    let text = message.lastText
                    let talkroom = Talkroom(name: name, uid: uid, roomNumber: roomKey, lastText: text)
                    self.talkrooms.append(talkroom)
                }
            }
        }catch {
            print("error Realm")
        }
    }
    
    func reload() {
        DispatchQueue.global().async {
            self.localDataGet()
            DispatchQueue.main.async {
                self.myTableview.reloadData()
            }
        }
    }
    
    func localdataObserve() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            // チャット履歴データの変更を監視する
            token = user.messages.observe { [weak self]  _ in
                self?.reload()
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    
    // tableviewのオートレイアウト
    func tableviewLayout() {
        view.addSubview(myTableview)
        self.myTableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    // データがないときのView
    func notingDataLayout() {
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.view.addSubview(topNottingDataLabel)
        self.view.addSubview(underNottingDataLabel)
        
        topNottingDataLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        underNottingDataLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topNottingDataLabel.snp.bottom).offset(10)
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

extension MessageHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 履歴があったらtableviewを表示
        if (talkrooms.count >= 1) {
            tableviewLayout()
            return talkrooms.count
        }else {
            // 履歴がなかった時はTableviewを表示しないでメッセージを表示
            notingDataLayout()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! CustomMessageTableViewCell
        cell.nameLabel.text = talkrooms[indexPath.row].name
        cell.underLabel.text = talkrooms[indexPath.row].lastText
        let uid = talkrooms[indexPath.row].uid
        let filePath = self.fileInDocumentsDirectory(filename: uid!)
        let image = self.loadImageFromPath(path: filePath)
        DispatchQueue.main.async {
            if (image != nil) {
                cell.avaterImageView.image = image
            }
        }
        return cell
    }
    // Cellをタップしたらメッセージ画面へ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomNumber = talkrooms[indexPath.row].roomNumber
        let otherUid = talkrooms[indexPath.row].uid
        let messageVC = MessageViewController()
        messageVC.alreadyRoomNumber = roomNumber
        messageVC.otherUid = otherUid
        let navi = UINavigationController(rootViewController: messageVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
}

extension MessageHistoryViewController: imageSaveProtocol {}
