//
//  UserByTappedViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class CollectionCellTappedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let tableArray: [String] = ["名前", "生年月日", "性別", "職業", "地域", "自己紹介", "趣味", "既往歴"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.rowHeight = 50
        tableView.allowsSelection = false
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

extension CollectionCellTappedViewController: UITableViewDelegate, UITableViewDataSource {

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
}
