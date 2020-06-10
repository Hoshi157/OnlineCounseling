//
//  TimelineViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class ResevationViewController: UIViewController {
    
    let sidemenuVC = SidemenuViewController()
    weak var sidemenuDelegate: SidemenuViewControllerDelegate?
    
    private var Reservations: [ReservationData] = []
    
    private var realm: Realm!
    private var token: NotificationToken!
    
    private var dateformatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "ja/jP")
        formatter.dateFormat = "yyyy年MM月dd日 HH時"
        return formatter
    }()
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let topNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21)
        label.text = "カウンセリング予約を表示する"
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let underNottingDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = "カウンセリング予約できます。\nプロフィールのカレンダーから\n予約してみましょう。"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(myTableView)
        localDataGet()
        localdataObserve()
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "カウンセリング予約"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25"), style: .plain, target: self, action: #selector(sidemenuButtonAction))
        
    }
    
    @objc func sidemenuButtonAction() {
        self.sidemenuDelegate?.sidemenuViewControllerDidRequestShowing(sidemenuVC, contentAvailability: true, animeted: true)
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
       
       // Realmからお気に入りデータを取得する
       func localDataGet() {
           Reservations = []
           do {
               realm = try Realm()
               let user = realm.objects(User.self).last!
               try realm.write {
                   for reservation in user.reservations {
                    let name = reservation.name
                    let uid = reservation.uid
                    let date: Date? = reservation.reservation
                    let dataSt = dateformatter.string(from:date!)
                    let reservationData = ReservationData(uid: uid, name: name, dateSt: dataSt)
                    self.Reservations.append(reservationData)
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
       // Realmのbookmarksを監視
       func localdataObserve() {
           do {
               realm = try Realm()
               let user = realm.objects(User.self).last!
               // ブックマークデータの変更を監視する
               token = user.reservations.observe { [weak self]  _ in
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

extension ResevationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 履歴があったらtableviewを表示
        if (Reservations.count >= 1) {
            tableviewLayout()
            return Reservations.count
        }else {
            // 履歴がなかった時はTableviewを表示しないでメッセージを表示
            notingDataLayout()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! CustomMessageTableViewCell
        cell.nameLabel.text = Reservations[indexPath.row].name
        cell.underLabel.text = "\(Reservations[indexPath.row].dateSt!)　の予約"
        let uid = Reservations[indexPath.row].uid
        let filePath = self.fileInDocumentsDirectory(filename: uid!)
        let image = self.loadImageFromPath(path: filePath)
        cell.avaterImageView.layer.cornerRadius = 10
        cell.avaterImageView.clipsToBounds = true
        DispatchQueue.main.async {
            if (image != nil) {
                cell.avaterImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResevationViewController: imageSaveProtocol {}
