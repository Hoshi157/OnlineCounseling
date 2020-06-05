//
//  MyPageViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avaterImageView: UIImageView!
    @IBOutlet weak var imageOnLabel: UILabel!
    @IBOutlet weak var singleWordLabel: UILabel!
    // tableviewを選択した時のIndexPath
    private var tableViewSelecteIndexpath: IndexPath!
    let sideVC = SidemenuViewController()
    let usersDB = Firestore.firestore().collection("users")
    
    // Realmのデータ
    private var name: String?
    private var birthdayDate: Date?
    private var gender: String?
    private var jobs: String?
    private var area: String?
    private var hobby: String?
    private var selfintroText: String?
    private var singlewordText: String?
    private var medicalhistoryText: String?
    private var photoImage: UIImage?
    private var uid: String?
    
    private var realm: Realm!
    private var formatter: DateFormatter = {
       let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        return format
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
    
    lazy var pickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
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
    
    private let tableArray: [String] = ["名前", "生年月日", "性別", "職業", "地域", "自己紹介", "趣味", "既往歴"]
    private let genderArray: [String] = [
        "未選択",
        "男", "女"]
    private let jobsArray: [String] = [
           "未選択",
           "営業", "販売,フード,アミューズメント", "医療・福祉", "企画・経営", "建築・土木",
           "ITエンジニア", "電気・電子・機械", "医薬・化学・素材", "コンサルタント・金融",
           "不動産専門職", "クリエイティブ", "技能工・設備・配送", "農業", "公共サービス",
           "管理・事務", "美容・ブライダル・ホテル", "保育・教育", "WEB・インターネット"
       ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(datePickerView)
        view.addSubview(pickerView)
        view.addSubview(pickerToolbar)
        
        pickerToolbar.items = [canselPickerButton, flexble, donePickerButton]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        title = "マイページを編集"
        // tableviewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        // avaterImageの設定
        avaterImageView.isUserInteractionEnabled = true
        avaterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avaterImageTapAction(_:))))
        avaterImageView.layer.cornerRadius = 10
        avaterImageView.clipsToBounds = true
        // ひとことラベルの設定
        singleWordLabel.isUserInteractionEnabled = true
        singleWordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleWordLabelTapAction(_:))))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データの取り出し(image以外)
        do {
        realm = try Realm()
        let user = realm.objects(User.self).last!
        self.name = user.name
        self.birthdayDate = user.birthdayDate
        self.jobs = user.jobs
        self.area = user.area
        self.hobby = user.hobby
        self.selfintroText = user.selfintroText
        self.singlewordText = user.singlewordText
        self.medicalhistoryText = user.medicalhistoryText
        self.gender = user.gender
        
        self.uid = user.uid
        }catch {
            print("error")
        }
        // ひとことラベルに表示する
        if (self.singlewordText != "") {
            self.singleWordLabel.text = self.singlewordText!
        }
        // アバター画像を表示する
        if (self.photoImage != nil) {
            DispatchQueue.main.async {
                self.avaterImageView.image = self.photoImage!
            }
            self.imageOnLabel.text = ""
        }else {
            DispatchQueue.main.async {
                self.avaterImageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // 戻る際にFirebaseへPostする
    @objc func backViewAction() {
        let post: [String: Any] = [
            "name": self.name!, "jobs": self.jobs!, "birthday": Timestamp(date: self.birthdayDate!),
            "area": self.area!, "hobby": self.hobby!, "gender": self.gender!, "medicalhistoryText": self.medicalhistoryText!,
            "singlewordText": self.singlewordText!, "selfintroText": self.selfintroText!
        ]
        // updataする
        usersDB.document(self.uid!).updateData(post)
        self.dismiss(animated: true, completion: nil)
    }
    // pickerのokボタン
    @objc func donePickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion: { (_) in
            // データの書き込み(tableViewのindexPathで絞り込み)
            if (self.tableViewSelecteIndexpath != nil) {
            do {
                self.realm = try Realm()
                let user = self.realm.objects(User.self).last!
                try self.realm.write {
                    switch (self.tableViewSelecteIndexpath.row) {
                    case 1:
                        // 生年月日
                        self.birthdayDate = self.datePickerView.date
                        user.birthdayDate = self.birthdayDate!
                case 2:
                    // 性別
                    user.gender = self.gender!
                case 3:
                    // 職業
                    user.jobs = self.jobs!
                default:
                    print("error")
                }
                }
            }catch {
                print("error")
            }
            }
        })
    }
    // pickerのキャンセルボタン
    @objc func canselPickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion: nil)
    }
    // 画像をタップしたらカメラ、アルバム起動しRealmへ保存する
    @objc func avaterImageTapAction(_ sender: UITapGestureRecognizer) {
        let aleatController = UIAlertController(title: "自分のアバターを設定する", message: "選択してください", preferredStyle: .alert)
            let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    self.present(picker,animated: true)
                }
            }
            aleatController.addAction(cameraAction)
            
            let photoAction = UIAlertAction(title: "アルバム", style: .default) { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    self.present(picker,animated: true)
                }}
            aleatController.addAction(photoAction)
            
            let canselAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            aleatController.addAction(canselAction)
            self.present(aleatController,animated: true)
    }
    // ひとことラベルタップ処理
    @objc func singleWordLabelTapAction(_ sender: UITapGestureRecognizer) {
        let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
        textInputVC.titleText = "カウンセラーに伝えておきたい事"
        self.navigationController?.pushViewController(textInputVC, animated: true)
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

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            let leftText = tableArray[0]
            textCell.leftLabel.text = leftText
            if (self.name != "") {
                textCell.underLabel.text = self.name
            }
            return textCell
        case 1:
            let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            let leftText = tableArray[1]
            pickerCell.textLabel?.text = leftText
            if (self.birthdayDate != Date()) {
                pickerCell.rightLabel.text = "\(formatter.string(from: self.birthdayDate!))"
                pickerCell.rightImage.image = UIImage()
            }
            return pickerCell
        case 2:
            let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            let leftText = tableArray[2]
            pickerCell.textLabel?.text = leftText
            if (self.gender != "") {
                pickerCell.rightLabel.text = self.gender!
                pickerCell.rightImage.image = UIImage()
            }
            return pickerCell
        case 3:
            let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            let leftText = tableArray[3]
            pickerCell.textLabel?.text = leftText
            if (self.jobs != "") {
                pickerCell.rightLabel.text = self.jobs!
                pickerCell.rightImage.image = UIImage()
            }
            return pickerCell
        case 4:
            let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            let leftText = tableArray[4]
            pickerCell.textLabel?.text = leftText
            if (self.area != "") {
                pickerCell.rightLabel.text = self.area!
                pickerCell.rightImage.image = UIImage()
            }
            return pickerCell
        case 5:
            let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            let leftText = tableArray[5]
            textCell.leftLabel.text = leftText
            if (self.selfintroText != "") {
                textCell.underLabel.text = self.selfintroText!
            }
            return textCell
        case 6:
            let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            let leftText = tableArray[6]
            textCell.leftLabel.text = leftText
            if (self.hobby != nil) {
                textCell.underLabel.text = self.hobby!
            }
            return textCell
        case 7:
            let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            let leftText = tableArray[7]
            textCell.leftLabel.text = leftText
            if (self.medicalhistoryText != nil) {
                textCell.underLabel.text = self.medicalhistoryText!
            }
            return textCell
        default:
            print("error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewSelecteIndexpath = indexPath
        pickerView.reloadAllComponents()
        
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
        case 2:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25 - 40, width: self.view.frame.width, height: 40)
            }, completion: nil)
        case 3:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.25 - 40, width: self.view.frame.width, height: 40)
            }, completion: nil)
        case 4:
            let areaVC = self.storyboard?.instantiateViewController(withIdentifier: "areaVC") as! AreaViewController
            self.navigationController?.pushViewController(areaVC, animated: true)
        case 5:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            textInputVC.titleText = "自己紹介"
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 6:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            textInputVC.titleText = "趣味"
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 7:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            textInputVC.titleText = "既往歴"
            self.navigationController?.pushViewController(textInputVC, animated: true)
        default:
            print("eroor")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0, 5, 6, 7:
            return 70
        case 1, 2, 3, 4:
            return 50
        default:
            print("error")
            return 0
        }
    }
}

extension MyPageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (tableViewSelecteIndexpath != nil) {
            switch (tableViewSelecteIndexpath.row) {
        case 2:
            return genderArray.count
        case 3:
            return jobsArray.count
        default:
            print("error")
            return Int()
        }
        }else {
            print("nil")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch (tableViewSelecteIndexpath.row) {
            case 2:
                return genderArray[row]
            case 3:
                return jobsArray[row]
            default:
                print("error")
                return ""
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at: tableViewSelecteIndexpath) as! CustomTableViewCell
        // ここでPickerの選択された値を変数へ格納
        switch (tableViewSelecteIndexpath.row) {
        case 2:
            cell.rightLabel.text = genderArray[row]
            self.gender = genderArray[row]
            cell.rightImage.image = UIImage()
        case 3:
            cell.rightLabel.text = jobsArray[row]
            self.jobs = jobsArray[row]
            cell.rightImage.image = UIImage()
        default:
            cell.rightLabel.text = ""
            print("error")
        }
    }
}

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.avaterImageView.image = photoImage
        // 画像のRealmへの書き込み
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                
            }
        }catch {
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
}
}
