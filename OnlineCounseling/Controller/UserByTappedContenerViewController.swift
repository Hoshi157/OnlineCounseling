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

class UserByTappedContenerViewController: UIViewController {
    
    lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    lazy var messageButton: MDCRaisedButton = {
       let button = MDCRaisedButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-chat-bubble-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var calendarButton: MDCRaisedButton = {
       let button = MDCRaisedButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        let image = #imageLiteral(resourceName: "icons8-カレンダー-25").withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(calendarTransitionAction), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
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
        
        let collectionByTappedVC = storyBoard.instantiateViewController(withIdentifier: "CollectionTapVC") as! CollectionCellTappedViewController
        
        addChild(collectionByTappedVC)
        view.addSubview(collectionByTappedVC.view)
        didMove(toParent: self)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
