//
//  TutorialViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents

class TutorialViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    var screenSizeWidth: CGFloat?
    
    lazy var myScrollView: UIScrollView = {
       let scrolleView = UIScrollView()
        scrolleView.frame = self.view.bounds
        scrolleView.contentSize = CGSize(width: self.view.bounds.width * 3, height: self.view.bounds.height)
        scrolleView.isPagingEnabled = true
        scrolleView.showsHorizontalScrollIndicator = false
        scrolleView.delegate = self
        return scrolleView
    }()
    
    private let myPageControl: UIPageControl = {
       let pagecontrol = UIPageControl()
        pagecontrol.numberOfPages = 3
        pagecontrol.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pagecontrol.currentPageIndicatorTintColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        return pagecontrol
    }()
    
    private let welcomeView: WelcomeView = {
        let view = WelcomeView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let explanatinView: UIView = {
       let view = ExplanationView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
       return view
    }()
    
    private let reservationExplatinView: ReservationExplanationView = {
        let view = ReservationExplanationView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    lazy var startButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.setTitle("開始する", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSizeWidth = screenSize.width
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        view.addSubview(myScrollView)
        view.addSubview(myPageControl)
        myScrollView.addSubview(welcomeView)
        myScrollView.addSubview(explanatinView)
        myScrollView.addSubview(reservationExplatinView)
        myScrollView.addSubview(startButton)
        
        myPageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-50)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        welcomeView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
        
        explanatinView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.myScrollView).offset(screenSizeWidth!)
            make.centerY.equalTo(self.myScrollView)
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
        
        reservationExplatinView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.myScrollView).offset(screenSizeWidth! * 2)
            make.centerY.equalTo(self.myScrollView)
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(reservationExplatinView.snp.bottom).offset(20)
            make.centerX.equalTo(self.myScrollView).offset(screenSizeWidth! * 2)
            make.height.equalTo(40)
            make.width.equalTo(200)
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

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        myPageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
