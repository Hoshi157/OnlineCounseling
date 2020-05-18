//
//  AccountTakeoverViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class AccountTakeoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let tableArray: [String] = ["メールアドレス", "パスワード", "パスワードの確認"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomAccountTakeOverTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTakeoverCell")
        tableView.rowHeight = 50

        // Do any additional setup after loading the view.
    }
    @IBAction func skipButtonAction(_ sender: Any) {
        let tabbarController = TabbarController()
        self.present(tabbarController, animated: true)
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

extension AccountTakeoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTakeoverCell", for: indexPath) as! CustomAccountTakeOverTableViewCell
        let text = tableArray[indexPath.row]
        cell.textField.placeholder = text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
