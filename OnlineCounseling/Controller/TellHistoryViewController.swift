//
//  TellHistoryViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TellHistoryViewController: UIViewController, IndicatorInfoProvider {
    
    let itemInfo: IndicatorInfo = "通話した相手"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "ImageNameOnlyTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageNameOnlyTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
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

extension TellHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNameOnlyTableViewCell", for: indexPath) as! ImageNameOnlyTableViewCell
        cell.avaterImageView.layer.cornerRadius = 10
        cell.avaterImageView.clipsToBounds = true
        return cell
    }
    
    
}
