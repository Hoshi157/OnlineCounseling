//
//  UserByTappedViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents

class CollectionCellTappedViewController: UIViewController {
    // tableviewに表示するユーザー情報を格納
    var profileDataDic: [String: Any] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    let screen = UIScreen.main.bounds
    private var formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        return format
    }()
    
    lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        return scrollView
    }()
    
    lazy var firstView: UIView = {
        let myView = UIView()
        myView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myView.layer.cornerRadius = 40
        myView.clipsToBounds = true
        myView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.8)
        return myView
    }()
    
    lazy var secoundView: UIView = {
       let myview = UIView()
        myview.layer.cornerRadius = 40
        myview.clipsToBounds = true
        myview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myview.frame = CGRect(x: self.firstView.frame.origin.x, y: self.firstView.frame.origin.y + self.firstView.frame.height + 5, width: self.view.frame.width, height: self.view.frame.height * 0.25)
        return myview
    }()
    
    lazy var thirdView: UIView = {
        let myview = UIView()
        myview.layer.cornerRadius = 40
        myview.clipsToBounds = true
        myview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myview.frame = CGRect(x: self.secoundView.frame.origin.x, y: self.secoundView.frame.origin.y + self.secoundView.frame.height + 5, width: self.view.frame.width, height: self.view.frame.height * 0.4)
        return myview
    }()
    
    var avaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.text = "Name"
        return label
    }()
    
    var bookmarkCountLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let bookmarkTextLabel: UILabel = {
        let label = UILabel()
        label.text = "お気に入り"
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    var bookmarkButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.setTitle("お気に入り", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
        button.setTitleFont(UIFont.systemFont(ofSize: 14, weight: .bold), for: .normal)
        return button
    }()
    
    private let singlewordLabel: UILabel = {
        let label = UILabel()
        label.text = "ひとこと"
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    var singlewordText: UILabel = {
        let label = UILabel()
        label.text = "ひとことテキスト"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let selfintroLabel: UILabel = {
        let label = UILabel()
        label.text = "自己紹介"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    var selfintroText: UILabel = {
        let label = UILabel()
        label.text = "自己紹介テキスト"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "プロフィール"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.register(UINib(nibName: "CustomTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTextTableCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        view.addSubview(myScrollView)
        myScrollView.addSubview(firstView)
        firstView.addSubview(avaterImageView)
        firstView.addSubview(nameLabel)
        firstView.addSubview(bookmarkCountLabel)
        firstView.addSubview(bookmarkTextLabel)
        firstView.addSubview(bookmarkButton)
        firstView.addSubview(singlewordLabel)
        firstView.addSubview(singlewordText)
        myScrollView.addSubview(secoundView)
        secoundView.addSubview(selfintroLabel)
        secoundView.addSubview(selfintroText)
        myScrollView.addSubview(thirdView)
        thirdView.addSubview(profileLabel)
        thirdView.addSubview(myTableView)
        
        avaterImageView.snp.makeConstraints { (make) in
            make.top.equalTo(firstView)
            make.right.equalTo(firstView)
            make.left.equalTo(firstView)
            make.height.equalTo(screen.height * 0.5)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avaterImageView.snp.bottom).offset(20)
            make.left.equalTo(firstView).offset(20)
            make.height.equalTo(25)
        }
        
        bookmarkCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        bookmarkTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookmarkCountLabel)
            make.left.equalTo(bookmarkCountLabel.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        bookmarkButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.right.equalTo(firstView).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(115)
        }
        
        singlewordLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookmarkCountLabel.snp.bottom).offset(20)
            make.height.equalTo(35)
        }
        
        singlewordText.snp.makeConstraints { (make) in
            make.top.equalTo(singlewordLabel.snp.bottom).offset(10)
            make.left.equalTo(firstView).offset(50)
            make.right.equalTo(firstView).offset(-50)
            make.bottom.equalTo(firstView).offset(-20)
        }
        
        selfintroLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secoundView).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        selfintroText.snp.makeConstraints { (make) in
            make.top.equalTo(selfintroLabel.snp.bottom).offset(10)
            make.left.equalTo(secoundView).offset(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(-20)
        }
        
        profileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdView).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(profileLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.9)
            make.height.equalTo(150)
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

extension CollectionCellTappedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dataのkeyの配列を作成
        let dataKeys: [String] = [String](profileDataDic.keys)
        let dataKey: String = dataKeys[indexPath.row]
        // 内容に応じてCell変更
        if (dataKey == "地域" || dataKey == "性別" || dataKey == "仕事") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            cell.textLabel?.text = dataKey
            cell.rightLabel.text = profileDataDic[dataKey] as? String
            cell.rightImage.image = UIImage()
            return cell
        }else if (dataKey == "趣味") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTextTableCell", for: indexPath) as! CustomTextTableViewCell
            cell.leftLabel.text = dataKey
            cell.underLabel.text = profileDataDic[dataKey] as? String
            return cell
        }else if (dataKey == "生年月日") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
            cell.textLabel?.text = dataKey
            cell.rightLabel.text = "\(formatter.string(from: profileDataDic[dataKey] as! Date))"
            cell.rightImage.image = UIImage()
            return cell
        }else {
            print("error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 内容に応じて高さ変更
        let dataKeys: [String] = [String](profileDataDic.keys)
        let dataKey: String = dataKeys[indexPath.row]
        // valueを判定するために取得(Date型もあるためオプショナル)
        let datavalue: String? = profileDataDic[dataKey] as? String
        if (datavalue == "") { // 空の場合は0
            return 0
        }
        if (dataKey == "趣味") {
            return 70
        }else {
            return 50
        }
    }
}
