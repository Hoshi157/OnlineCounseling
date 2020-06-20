//
//  ViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MaterialComponents

class RootViewController: UIViewController {
    
    @IBOutlet weak var startButton: MDCRaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        startButton.addTarget(self, action: #selector(walkthrouthAction), for: .touchUpInside)
    }
    
    @objc func walkthrouthAction() {
        let tutorialVC = TutorialViewController()
        tutorialVC.modalPresentationStyle = .fullScreen
        present(tutorialVC, animated: true)
    }
}

