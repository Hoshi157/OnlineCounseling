//
//  ProfileRegisterViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class ProfileRegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var tableViewSelecteIndexpath: IndexPath!
    
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

        // Do any additional setup after loading the view.
        
        view.addSubview(datePickerView)
        view.addSubview(pickerView)
        view.addSubview(pickerToolbar)
        
        pickerToolbar.items = [canselPickerButton, flexble, donePickerButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.rowHeight = 50
    }
    
    @objc func backViewAction(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func donePickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion: nil)
    }
    
    @objc func canselPickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
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

extension ProfileRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pickerCell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
        let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
        
        switch (indexPath.row) {
        case 0:
            let leftText = tableArray[0]
            textCell.leftLabel.text = leftText
            return textCell
        case 1:
            let leftText = tableArray[1]
            pickerCell.textLabel?.text = leftText
            return pickerCell
        case 2:
            let leftText = tableArray[2]
            pickerCell.textLabel?.text = leftText
            return pickerCell
        case 3:
            let leftText = tableArray[3]
            pickerCell.textLabel?.text = leftText
            return pickerCell
        case 4:
            let leftText = tableArray[4]
            pickerCell.textLabel?.text = leftText
            return pickerCell
        case 5:
            let leftText = tableArray[5]
            textCell.leftLabel.text = leftText
            return textCell
        case 6:
            let leftText = tableArray[6]
            textCell.leftLabel.text = leftText
            return textCell
        case 7:
            let leftText = tableArray[7]
            textCell.leftLabel.text = leftText
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
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 6:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 7:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            self.navigationController?.pushViewController(textInputVC, animated: true)
        default:
            print("eroor")
            return
        }
    }
}

extension ProfileRegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}
