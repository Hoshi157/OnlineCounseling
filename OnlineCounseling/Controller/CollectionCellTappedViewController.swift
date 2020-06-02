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
    // tableviewに表示するユーザー情報を格納
    var profileDataDic: [String: Any] = [:] {
        didSet {
            print(profileDataDic, "profileDataDic")
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
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 10) // ボタンがあるから余分に足す
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let myView = UIView()
        myView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myView.frame = CGRect(x: self.screen.origin.x, y: self.screen.origin.y - 45, width: self.view.frame.width, height: self.myScrollView.contentSize.height)
        return myView
    }()
    var avaterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
        return imageView
    }()
    
    var nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.text = "Name"
        return label
    }()
    
    var jobsLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.text = "Jobs"
        return label
    }()
    
    var genderImageView: UIImageView = {
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
    
    var singleWordLabel: UILabel = {
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
    
    var selfIntroInputLabel: UILabel = {
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
            make.height.equalTo(240)
        }
        // Do any additional setup after loading the view.
    }
    // セルの高さの合計に合わせてtableviewの高さを決める
    func automaticTableviewHight() {
        self.view.layoutIfNeeded()
        print(myTableView.contentSize.height, "tableviewの高さ")
        myTableView.frame.size.height = myTableView.contentSize.height
        automaticScrollviewHight()
    }
    // tableviewの可変に合わせてscrollviewを可変にする
    func automaticScrollviewHight() {
        let viewBottomOrigin: CGFloat = self.view.frame.origin.y + self.view.frame.size.height
        let tableviewBottomOrigin: CGFloat = self.myTableView.frame.origin.y + self.myTableView.frame.size.height
        // tableViewがViewより大きい場合,
        if (tableviewBottomOrigin > viewBottomOrigin) {
            // 大きい分だけ引き伸ばす
            let tableviewRemainig = tableviewBottomOrigin - viewBottomOrigin
            print(tableviewRemainig, "はみ出した分")
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
        return profileDataDic.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // dataのkeyの配列を作成
    let dataKeys: [String] = [String](profileDataDic.keys)
    let dataKey: String = dataKeys[indexPath.row]
    // 内容に応じてCell変更
    if (dataKey == "地域" ) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = dataKey
        cell.rightLabel.text = profileDataDic[dataKey] as? String
        cell.rightImage.image = UIImage()
        return cell
    }else if (dataKey == "趣味" || dataKey == "既往歴" ) {
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
        if (dataKey  == "既往歴" || dataKey == "趣味") {
            return 70
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // heightForRowの後に一度のみ検知する
        let rowAddNum = indexPath.row + 1
        if (self.profileDataDic.count == rowAddNum) {
            print("検知1")
            self.automaticTableviewHight()
        }
    }
    
}
