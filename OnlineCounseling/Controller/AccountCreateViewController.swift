//
//  AccountCreateViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents

class AccountCreateViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var consentButton: MDCRaisedButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tableArray = ["名前", "生年月日"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.rowHeight = 50
        // Do any additional setup after loading the view.
        
    }
    
    @objc func backViewAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func consentButtonAction(_ sender: Any) {
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
        print(tableArray.count)
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pickercell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
        let textCell: CustomTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
        
        switch (indexPath.row) {
        case 0:
            let text = tableArray[0]
            textCell.leftLabel.text = text
            return textCell
        case 1:
            let text = tableArray[1]
            pickercell.textLabel?.text = text
            return pickercell
        default:
            print("error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        switch (indexPath.row) {
        case 0:
            let textInputVC = self.storyboard?.instantiateViewController(withIdentifier: "textInputVC") as! TextInputProfileViewController
            self.navigationController?.pushViewController(textInputVC, animated: true)
        case 1:
            print("生年月日")
        default:
            print("error")
            return
        }
    }
}
