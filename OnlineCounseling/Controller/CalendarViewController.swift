//
//  CalendarViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift
import Firebase
import UserNotifications

class CalendarViewController: UIViewController {
    // 選択されているかFlag
    private var isPlayingCalendar: Bool = false
    private var isPlayinfTimeTable: Bool = false
    // timeTableview
    private let timeArray = [
        "0時~1時", "1時~2時", "2時~3時", "3時~4時", "4時~5時", "5時~6時", "6時~7時", "7時~8時", "8時~9時", "9時~10時", "10時~11時", "11時~12時",
        "12時~13時", "13時~14時", "14時~15時", "15時~16時", "16時~17時", "17時~18時", "18時~19時",
        "19時~20時", "20時~21時", "21時~22時", "22時~23時", "23時=24時"
    ]
    
    var otherUid: String?
    var otherName: String?
    
    private var yearNumber: Int?
    private var monthNumber: Int?
    private var dayNumber: Int?
    private var timeNumber: Int?
    
    private var timeArrayText: String?
    private var currentSelectedDate: String?
    // Realm
    private var realm: Realm!
    private var uid: String?
    private var name: String?
    // Firebae
    private let usersDB = Firestore.firestore().collection("users")
    // プッシュ通知
    private var trigger: UNNotificationTrigger!
    
    // プッシュ送信の表示内容などを設定
    private var content: UNMutableNotificationContent = {
        let Content = UNMutableNotificationContent()
        Content.title = "カウンセリング5分前です"
        Content.sound = .default
        return Content
    }()
    
    private var dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "ja/jP")
        formatter.dateFormat = "yyyy/MM/dd HH"
        return formatter
    }()
    
    private var alert = AlertController()
    
    lazy var myCalendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendar.appearance.todayColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        calendar.appearance.headerTitleColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        calendar.appearance.selectionColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "予約日、時間を選択してください"
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.rowHeight = 50
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarCell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(myCalendar)
        view.addSubview(selectedDateLabel)
        view.addSubview(tableView)
        // navigation
        title = "予約ページ"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1).withAlphaComponent(0.3)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "予約する", style: .plain, target: self, action: #selector(ReservationButtonAction))
        
        myCalendar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(80)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        selectedDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(myCalendar.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(45)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectedDateLabel.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            self.uid = user.uid
            self.name = user.name
        }catch {
            print(error.localizedDescription, "error Realm")
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    // 予約ボタンタップ処理
    @objc func ReservationButtonAction() {
        if (isPlayingCalendar == true && isPlayinfTimeTable == true) {
            guard let reservationDateText = selectedDateLabel.text else { return }
            self.postToRocaldata(completion: { (date) in
                self.postToCloud(date: date)
                self.localNotificationRequest(date: date) // ここがクラッシュ
            })
            self.alert.okAlert(title: "予約しました", message: "\(reservationDateText)にて\n予約致しました。", currentController: self, completionHandler: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        }else {
            self.alert.okAlert(title: "予約できません", message: "予約日時を正しく設定してください", currentController: self)
        }
    }
    // Realmに予約日時を追加
    func postToRocaldata(completion: (_ date: Date?) -> Void){
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let date: Date? = self.dateformatter.date(from: "\(self.yearNumber!)/\(self.monthNumber!)/\(self.dayNumber!) \(self.timeNumber!)")
            try realm.write {
                let reservation = Reservation(value: ["uid": self.otherUid!, "name": self.otherName!, "reservation": date!])
                user.reservations.append(reservation)
            }
            completion(date)
        }catch {
            print(error.localizedDescription, "error Realm")
            completion(nil)
        }
    }
    // Firebaseに予約日時を追加(自分と相手)
    func postToCloud(date: Date?) {
        if (date != nil) {
            let postToSelfdata: [String: Any] = ["uid": self.otherUid!, "name": self.otherName!, "reservationDate": Timestamp(date: date!)]
            usersDB.document(self.uid!).collection("reservation").addDocument(data: postToSelfdata)
            let postToOtherdata: [String: Any] = ["uid": self.uid!, "name": self.name!, "reservationDate": Timestamp(date: date!)]
            usersDB.document(self.otherUid!).collection("reservation").addDocument(data: postToOtherdata)
        }
    }
    // プッシュ送信をリクエストする(カウンセリング時間の5分前に通知)
    func localNotificationRequest(date: Date?) {
        print("リクエスト処理")
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
        if let hour = dateComponent.hour {
            dateComponent.hour = hour - 1
        }
        if let minute = dateComponent.minute {
            dateComponent.minute = minute + 55
        }
        trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponent, repeats: false)
        print(dateComponent, "指定したdateComponemt")
        let dateSt = dateformatter.string(from: date!)
        content.body = "カウンセリングは\(dateSt)~1時間となっております。"
        let request = UNNotificationRequest.init(identifier: "request", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
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

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
        cell.textLabel?.text = timeArray[indexPath.row]
        
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.2030714897)
        cell.selectedBackgroundView = cellSelectedBgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isPlayinfTimeTable = true
        timeArrayText = timeArray[indexPath.row]
        self.timeNumber = indexPath.row
        guard let timeText = timeArrayText else {return}
        if (currentSelectedDate != nil) {
            guard let currentDate: String = currentSelectedDate else {return}
            self.selectedDateLabel.text = "\(currentDate)\(timeText)"
        }else {
            self.selectedDateLabel.text = "予約日を選択してください\(timeText)"
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if (self.isPlayingCalendar == false) {
            self.isPlayingCalendar = true
            let tmpDate = Calendar(identifier: .gregorian)
            let year = tmpDate.component(.year, from: date)
            let month = tmpDate.component(.month, from: date)
            let day = tmpDate.component(.day, from: date)
            self.yearNumber = year
            self.monthNumber = month
            self.dayNumber = day
            self.currentSelectedDate = "\(year)年\(month)月\(day)日"
            if (self.isPlayinfTimeTable == true) {
                guard let timeText = timeArrayText else {return}
                self.selectedDateLabel.text = "\(year)年\(month)月\(day)日\(timeText)"
            }else {
                self.selectedDateLabel.text = "\(year)年\(month)月\(day)日(時間を選択してください)"
            }
        }else {
            self.isPlayingCalendar = false
            self.currentSelectedDate = nil
            
            if (myCalendar.selectedDate != nil) {
                let selectedData = myCalendar.selectedDate
                myCalendar.deselect(selectedData!)
                
                if (self.isPlayinfTimeTable == true) {
                    guard let timeText = timeArrayText else {return}
                    self.selectedDateLabel.text = "(予約日を選択してください)\(timeText)"
                }else {
                    self.selectedDateLabel.text = "予約日、時間を選択してください"
                }
            }
        }
    }
    // 過去のカレンダーは選択不可にする
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
