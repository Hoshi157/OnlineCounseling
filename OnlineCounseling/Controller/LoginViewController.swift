//
//  LoginViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let tableviewArray: [String] = ["メールアドレス", "パスワード", "パスワードの確認"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25"), style: .plain, target: self, action: #selector(backViewAction))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomAccountTakeOverTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTakeoverCell")
        tableView.rowHeight = 50

        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarController
        tabbarController.modalPresentationStyle = .fullScreen
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

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTakeoverCell", for: indexPath) as! CustomAccountTakeOverTableViewCell
        let text = tableviewArray[indexPath.row]
        cell.textField.placeholder = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
