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

class CalendarViewController: UIViewController {
    
    private let timeArray = [
        "0時~1時", "1時~2時", "2時~3時", "3時~4時", "4時~5時", "5時~6時", "6時~7時", "7時~8時", "8時~9時", "9時~10時", "10時~11時", "11時~12時",
    "12時~13時", "13時~14時", "14時~15時", "15時~16時", "16時~17時", "17時~18時", "18時~19時",
    "19時~20時", "20時~21時", "21時~22時", "22時~23時", "23時=24時"
    ]
    
    private var myCalendar: FSCalendar = {
      let calendar = FSCalendar()
        calendar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return calendar
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
        view.addSubview(tableView)
        title = "予約ページ"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        myCalendar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(80)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(myCalendar.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
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
        return cell
    }
}
