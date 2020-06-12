//
//  TellHistoryViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift
import SnapKit
// カウンセリングした履歴画面
class TellHistoryViewController: UIViewController, IndicatorInfoProvider {
    
    let itemInfo: IndicatorInfo = "通話した相手"
    private var realm: Realm!
    private var token: NotificationToken!
    private var counselors: [Counselor] = []
    
    lazy var myTableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ImageNameOnlyTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageNameOnlyTableViewCell")
        return tableView
    }()
    
    private let topNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21)
        label.text = "カウンセリング履歴です"
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let underNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "カウンセリングしてみましょう。\nプロフィール画面のカレンダーから\n予約してみましょう。"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localDataGet()
        localdataObserve()
        
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // tableviewのオートレイアウト
    func tableviewLayout() {
        view.addSubview(myTableView)
        self.myTableView.snp.makeConstraints { (make) in
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
    
    // Realmからカウンセリング履歴を取得する
    func localDataGet() {
        counselors = []
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                for counseling in user.counselings {
                    let name = counseling.name
                    let uid = counseling.uid
                    let counselingData = Counselor(name: name, uid: uid)
                    self.counselors.append(counselingData)
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
                self.myTableView.reloadData()
            }
        }
    }
    // Realmのcounselingsを監視
    func localdataObserve() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            // ブックマークデータの変更を監視する
            token = user.counselings.observe { [weak self]  _ in
                self?.reload()
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

extension TellHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 履歴があったらtableviewを表示
        if (counselors.count >= 1) {
            tableviewLayout()
            return counselors.count
        }else {
            // 履歴がなかった時はTableviewを表示しないでメッセージを表示
            notingDataLayout()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNameOnlyTableViewCell", for: indexPath) as! ImageNameOnlyTableViewCell
        cell.nameLabel.text = counselors[indexPath.row].name
        let uid = counselors[indexPath.row].uid
        let filePath = self.fileInDocumentsDirectory(filename: uid!)
        let image = self.loadImageFromPath(path: filePath)
        cell.avaterImageView.layer.cornerRadius = 30
        cell.avaterImageView.clipsToBounds = true
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
        userByTapVC.userTapUid = counselors[indexPath.row].uid
        userByTapVC.otherName = counselors[indexPath.row].name
        present(userByTapVC, animated: true)
    }
    
}

extension TellHistoryViewController: imageSaveProtocol {}
