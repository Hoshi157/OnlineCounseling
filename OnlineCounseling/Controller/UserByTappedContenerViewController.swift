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
    
    lazy var messageButton: MDCRaisedButton = {
       let button = MDCRaisedButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = .red
        let image = #imageLiteral(resourceName: "icons8-chat-bubble-25")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var videoCallButton: MDCRaisedButton = {
       let button = MDCRaisedButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = .blue
        let image = #imageLiteral(resourceName: "icons8-ホーム-25")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var dismissButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = .gray
        let image = #imageLiteral(resourceName: "icons8-カウンセラー-25")
        button.setImage(image, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let collectionByTappedVC = storyboard.instantiateViewController(withIdentifier: "CollectionTapVC") as! CollectionCellTappedViewController
        
        addChild(collectionByTappedVC)
        view.addSubview(collectionByTappedVC.view)
        didMove(toParent: self)
        
        view.addSubview(messageButton)
        view.addSubview(videoCallButton)
        view.addSubview(dismissButton)
        
        messageButton.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.left.equalTo(self.view).offset(50)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        videoCallButton.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.bottom.equalTo(messageButton)
            make.right.equalTo(self.view).offset(-50)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(50)
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
