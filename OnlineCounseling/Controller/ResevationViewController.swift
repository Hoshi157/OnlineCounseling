//
//  TimelineViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit

class ResevationViewController: UIViewController {
    
    let sidemenuVC = SidemenuViewController()
    weak var sidemenuDelegate: SidemenuViewControllerDelegate?
    
    lazy var myTableView: UITableView = {
      let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        tableView.rowHeight = 70
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(myTableView)

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "カウンセリング予約"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25"), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25"), style: .plain, target: self, action: #selector(sidemenuButtonAction))
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    @objc func sidemenuButtonAction() {
        self.sidemenuDelegate?.sidemenuViewControllerDidRequestShowing(sidemenuVC, contentAvailability: true, animeted: true, currentViewController: self)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! CustomMessageTableViewCell
        cell.nameLabel.text = "Name"
        return cell
    }
    
    
}
