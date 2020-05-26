//
//  UserByTappedViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit

class CollectionCellTappedViewController: UIViewController {
    
    private let tableArray: [String] = ["1", "2", "3", "4", "5"]
    
    let screen = UIScreen.main.bounds
    
    lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 40)
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let myView = UIView()
        myView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myView.frame = CGRect(x: self.screen.origin.x, y: self.screen.origin.y - 45, width: self.view.frame.width, height: self.myScrollView.contentSize.height)
        return myView
    }()
    private var avaterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
        return imageView
    }()
    
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.text = "Name"
        return label
    }()
    
    private var jobsLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.text = "Jobs"
        return label
    }()
    
    private var genderImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icons8-性中立ユーザー-25").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return imageView
    }()
    
    lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icons8-スター-25").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookmarkImageTapped(_:))))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var singleWordLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 0.2)
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private let selfIntroTitle: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "自己紹介"
        return label
    }()
    
    private var selfIntroInputLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        return label
    }()
    
    lazy var myTableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myScrollView)
        myScrollView.addSubview(contentView)
        contentView.addSubview(avaterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobsLabel)
        contentView.addSubview(genderImageView)
        contentView.addSubview(bookmarkImageView)
        contentView.addSubview(singleWordLabel)
        contentView.addSubview(selfIntroTitle)
        contentView.addSubview(selfIntroInputLabel)
        contentView.addSubview(myTableView)
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        avaterImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.right.equalTo(contentView)
            make.left.equalTo(contentView)
            make.height.equalTo(400)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avaterImageView.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(35)
        }
        
        jobsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(20)
            make.height.equalTo(35)
        }
        
        genderImageView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.right.equalTo(self.view).offset(-30)
            make.size.equalTo(40)
        }
        
        
        
        bookmarkImageView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.right.equalTo(genderImageView.snp.left).offset(-15)
            make.size.equalTo(40)
        }
        
        singleWordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(100)
        }
        
        selfIntroTitle.snp.makeConstraints { (make) in
            make.top.equalTo(singleWordLabel.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        selfIntroInputLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selfIntroTitle.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(100)
        }
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(selfIntroInputLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            // ここのtableViewの値は最高値
            make.height.equalTo(400)
        }
        // Do any additional setup after loading the view.
    }
    
    func automaticTableviewHight() {
        self.view.layoutIfNeeded()
        myTableView.frame.size.height = myTableView.contentSize.height
        automaticScrollviewHight()
    }
    
    func automaticScrollviewHight() {
        // tableViewがViewより大きい場合,
        let viewBottomOrigin: CGFloat = self.view.frame.origin.y + self.view.frame.size.height
        let tableviewBottomOrigin: CGFloat = self.myTableView.frame.origin.y + self.myTableView.frame.size.height
        
        if (tableviewBottomOrigin > viewBottomOrigin) {
            let tableviewRemainig = tableviewBottomOrigin - viewBottomOrigin
            myScrollView.contentSize.height += tableviewRemainig
        }
    }
    
    @objc func bookmarkImageTapped(_ sender: UITapGestureRecognizer) {
        print("tap")
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
    let arrayText = tableArray[indexPath.row]
    // 内容に応じてCell変更
    if (arrayText == "1" || arrayText == "3") {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }else if (arrayText == "2" || arrayText == "4" || arrayText == "5") {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
        cell.leftLabel.text = tableArray[indexPath.row]
        return cell
    }else {
        print("error")
        return UITableViewCell()
    }
 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 内容に応じて高さ変更
        let arrayText = self.tableArray[indexPath.row]
        if (arrayText  == "1" || arrayText == "3") {
            return 50
        }else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 一度のみ検知する
        let rowAddNum = indexPath.row + 1
        if (self.tableArray.count == rowAddNum) {
            self.automaticTableviewHight()
        }
    }
    
}
