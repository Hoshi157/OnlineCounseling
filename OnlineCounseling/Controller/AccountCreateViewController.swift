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

class AccountCreateViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var consentButton: MDCRaisedButton!
    
    private let tableArray = ["名前", "生年月日"]
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        view.addSubview(datePickerView)
        view.addSubview(pickerToolbar)
        pickerToolbar.items = [canselPickerButton, flexble, donePickerButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))

        // Do any additional setup after loading the view.
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.accountLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        
        print(myTableView.frame.height)
    }
    
    @objc func backViewAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func donePickerAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.datePickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.25)
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion: nil)
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
        let pickercell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
        let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
        print(indexPath)
        switch (indexPath.row) {
        case 0:
            let text = tableArray[0]
            textCell.leftLabel.text = text
            textCell.backgroundColor = .red
            print(textCell.frame.height)
            return textCell
        case 1:
            let text = tableArray[1]
            pickercell.textLabel?.text = text
            pickercell.backgroundColor = .blue
            print(pickercell.frame.height)
            return pickercell
        default:
            print("error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}
