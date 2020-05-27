//
//  AccountCreateViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import RealmSwift

class AccountCreateViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var consentButton: MDCRaisedButton!
    
    private var tableViewSelecteIndexpath: IndexPath!
    private let tableArray = ["名前", "生年月日"]
    
    private var realm: Realm!
    private var name: String?
    private var date: Date?
    // もとから書いてあるテキスト(underLabelに)
    private let originalText = "自由に記入してください"
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        return tableView
    }()
    
    lazy var datePickerView: UIDatePicker = {
       let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.locale = Locale.current
        picker.timeZone = NSTimeZone.local
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
        return picker
    }()
    
    lazy var pickerToolbar: UIToolbar = {
       let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        return toolBar
    }()
    
    lazy var donePickerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(donePickerAction))
        return button
    }()
    
    lazy var canselPickerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(canselPickerAction))
        return button
    }()
    
    lazy var flexble: UIBarButtonItem = {
        let spece = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        spece.width = self.view.frame.width * 0.6
        return spece
    }()
    
    private var formatter: DateFormatter = {
       let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        return format
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        view.addSubview(datePickerView)
        view.addSubview(pickerToolbar)
        pickerToolbar.items = [canselPickerButton, flexble, donePickerButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        
        self.myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.accountLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(120)
        }
        // まずはUser情報をrealmへ保存(開始時一度のみ)
        do {
            realm = try Realm()
            if (realm.objects(User.self).last == nil) {
                let myUser = User()
                try realm.write {
                    realm.add(myUser)
                    print(realm.objects(User.self))
                }
            }
        }catch {
            print("error")
        }

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データの取り出し
        do {
            realm = try Realm()
            // lastを忘れない!!
            let user = realm.objects(User.self).last!
            print(realm.objects(User.self)) //複数入ってないか確認
            self.name = user.name
            self.date = user.birthdayDate
        }catch {
            print("error")
        }
        
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    @objc func backViewAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func donePickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion:{ (_) in
            self.date = self.datePickerView.date
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
            // 生年月日をRealmに書き込み
            do {
                self.realm = try Realm()
                let user = self.realm.objects(User.self).last!
                print(user, "dateのcompletion")
                try self.realm.write {
                    user.birthdayDate = self.date!
                }
                }catch {
                    print("error")
            }
        })
    }
    
    @objc func canselPickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                   self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
                   self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
               }, completion: nil)
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

extension AccountCreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            textCell.leftLabel.text = tableArray[indexPath.row]
            // ここはもとのデータなら何もしない
            if (name != "") {
            textCell.underLabel.text = name
            }
            return textCell
        case 1:
            let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            pickerCell.textLabel?.text = tableArray[indexPath.row]
            //　上記Nameと同じ(が入力されてしまう)
            if (self.date != Date()) {
                pickerCell.rightLabel.text = "\(self.formatter.string(from: date!))"
                pickerCell.rightImage.image = UIImage()
            }
            return pickerCell
        default:
            print("error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    tableViewSelecteIndexpath = indexPath
        switch (indexPath.row) {
        case 0:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            textInputVC.titleText = "名前"
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 1:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25 - 40, width: self.view.frame.width, height: 40)
            }, completion: nil)
        default:
            print("error")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 内容が決まっているからIndexPathで判定する
        switch (indexPath.row) {
        case 0:
            return 70
        case 1:
            return 50
        default:
            print("error")
            return 0
        }
    }
}
