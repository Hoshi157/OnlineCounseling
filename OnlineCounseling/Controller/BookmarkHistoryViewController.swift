//
//  BookmarkHistoryViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SnapKit
import RealmSwift
// お気に入り履歴
class BookmarkHistoryViewController: UIViewController {
    // Realm
    private var realm: Realm!
    private var token: NotificationToken!
    // Cellのデータ配列
    var bookmarks: [Bookmark] = []
    // 上タブのタイトル
    let itemInfo:IndicatorInfo = "お気に入り"
    
    lazy var myTableview: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "ImageNameOnlyTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageNameOnlyTableViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let topNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21)
        label.text = "お気に入り履歴を表示する"
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let underNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "お気に入りリストとして保存できます。\nプロフィール欄から☆マークをタップして\nリストに保存しましょう。"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localDataGet()
        
        // Do any additional setup after loading the view.
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
    
    // Realmからお気に入りデータを取得する
    func localDataGet() {
        bookmarks = []
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            // ブックマークデータの変更を監視する
            token = user.bookmarks.observe { [weak self]  _ in
                self?.reload()
            }
            try realm.write {
                for bookmark in user.bookmarks {
                    let name = bookmark.otherName
                    let uid = bookmark.otherUid
                    let bookmarkData = Bookmark(name: name, uid: uid)
                    self.bookmarks.append(bookmarkData)
                }
            }
        }catch {
            print("error Realm")
        }
    }
    
    func reload() {
        DispatchQueue.global().async {
            self.getdataAtReload()
            DispatchQueue.main.async {
                self.myTableview.reloadData()
            }
        }
    }
    
    func getdataAtReload() {
        bookmarks = []
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                for bookmark in user.bookmarks {
                    let name = bookmark.otherName
                    let uid = bookmark.otherUid
                    let bookmarkData = Bookmark(name: name, uid: uid)
                    self.bookmarks.append(bookmarkData)
                }
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

extension BookmarkHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 履歴があったらtableviewを表示
        print(bookmarks.count, "bookmarks.count!!!!")
        if (bookmarks.count >= 1) {
            tableviewLayout()
            return bookmarks.count
        }else {
            // 履歴がなかった時はTableviewを表示しないでメッセージを表示
            notingDataLayout()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNameOnlyTableViewCell", for: indexPath) as! ImageNameOnlyTableViewCell
        cell.nameLabel.text = bookmarks[indexPath.row].name
        let uid = bookmarks[indexPath.row].uid
        let filePath = self.fileInDocumentsDirectory(filename: uid!)
        let image = self.loadImageFromPath(path: filePath)
        DispatchQueue.main.async {
            if (image != nil) {
                cell.avaterImageView.image = image
            }
        }
        return cell
    }
    // Cellをタップしたらプロフィール画面へ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userByTapVC = UserByTappedContenerViewController()
        userByTapVC.modalPresentationStyle = .fullScreen
        // 相手の名前,uidを入力する
        userByTapVC.userTapUid = bookmarks[indexPath.row].uid
        userByTapVC.otherName = bookmarks[indexPath.row].name
        present(userByTapVC, animated: true)
    }
}

extension BookmarkHistoryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension BookmarkHistoryViewController: imageSaveProtocol {}
