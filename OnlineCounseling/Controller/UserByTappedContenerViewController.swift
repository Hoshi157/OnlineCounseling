//
//  UserByTappedContenerViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Firebase

class UserByTappedContenerViewController: UIViewController {
    
    lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let collectionByTappedVC = CollectionCellTappedViewController()
    private let userDB = Firestore.firestore().collection("users")
    // タップしたUserデータのUid(presentした時に格納される)
    var userTapUid: String?
    
    lazy var messageButton: MDCFloatingButton = {
       let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-chat-bubble-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var calendarButton: MDCFloatingButton = {
       let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-カレンダー-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(calendarTransitionAction), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: MDCFloatingButton = {
        let button = MDCFloatingButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1).withAlphaComponent(0.8)
        let image = #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backViewAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 子Viewにした後でウィジット類をaddSubviewにているためボタンの方が上にくる
        addChild(collectionByTappedVC)
        view.addSubview(collectionByTappedVC.view)
        didMove(toParent: self)
        // ウィジット類
        view.addSubview(messageButton)
        view.addSubview(calendarButton)
        view.addSubview(dismissButton)
        
        messageButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.left.equalTo(self.view).offset(80)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        calendarButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.bottom.equalTo(messageButton)
            make.right.equalTo(self.view).offset(-80)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(20)
        }
        
        getData()

        // Do any additional setup after loading the view.
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func calendarTransitionAction() {
        let calendarVC = CalendarViewController()
        let naviController = UINavigationController(rootViewController: calendarVC)
        naviController.modalPresentationStyle = .fullScreen
        present(naviController, animated: true)
    }
    // user情報を取得
    func getData() {
        // childViewcontrollerを取得
        let childVC = self.children[0] as! CollectionCellTappedViewController
        if let cellUid = self.userTapUid {
            userDB.document(cellUid).getDocument { document, error in
                guard let data = document?.data() else {
                    return
                }
                // データの参照
                let name = data["name"] as! String
                let jobs = data["jobs"] as! String
                let gender = data["gender"] as! String
                let singleword = data["singlewordText"] as! String
                let selfinfo = data["selfintroText"] as! String
                // ここからはtableviewのデータ
                let birthday = data["birthday"] as! Timestamp
                let birthdayDate = birthday.dateValue()  // Date型にキャストしてから表示
                let area = data["area"] as! String
                let hobby = data["hobby"] as! String
                let medecalhistory = data["medicalhistoryText"] as! String
                // データをchildVCへ
                childVC.nameLabel.text = name
                childVC.jobsLabel.text = jobs
                if (gender == "男性") {
                    childVC.genderImageView.image = #imageLiteral(resourceName: "icons8-ユーザ男性-25-2").withRenderingMode(.alwaysTemplate)
                    childVC.genderImageView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                }else if (gender == "女性") {
                    childVC.genderImageView.image = #imageLiteral(resourceName: "icons8-ユーザー女性-25").withRenderingMode(.alwaysTemplate)
                    childVC.genderImageView.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }
                childVC.singleWordLabel.text = singleword
                childVC.selfIntroInputLabel.text = selfinfo
                // ここからはtableviewのデータ(dictionary型にて渡す)
                let profileDataDic: [String: Any] = ["生年月日": birthdayDate, "地域": area, "趣味": hobby, "既往歴": medecalhistory]
                childVC.profileDataDic = profileDataDic
            }
        }
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
