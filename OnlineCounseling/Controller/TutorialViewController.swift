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
// チュートリアル画面
class TutorialViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    var screenSizeWidth: CGFloat?
    //スクロールビューは横3ページ分で設定
    lazy var myScrollView: UIScrollView = {
       let scrolleView = UIScrollView()
        scrolleView.frame = self.view.bounds
        scrolleView.contentSize = CGSize(width: self.view.bounds.width * 3, height: self.view.bounds.height)
        scrolleView.isPagingEnabled = true // これでページング可能
        scrolleView.showsHorizontalScrollIndicator = false // 垂直スクロールバー表示しない
        scrolleView.delegate = self
        return scrolleView
    }()
    // ページコントロール
    private let myPageControl: UIPageControl = {
       let pagecontrol = UIPageControl()
        pagecontrol.numberOfPages = 3
        pagecontrol.pageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) // 非選択時
        pagecontrol.currentPageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // 選択時
        return pagecontrol
    }()
    // チュートリアルNibを3つ用意
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
        button.backgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSizeWidth = screenSize.width
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.85)
        
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
            make.width.equalTo(250)
        }
        
        

        // Do any additional setup after loading the view.
    }
    // スタートボタンを押したらTabbarVCのchildを解消
    @objc func startButtonAction() {
        willMove(toParent: self)
        removeFromParent()
        view.removeFromSuperview()
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
    //　スクロールした後
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロールビューをx方向に移動した分 / フレームワイド = ページコントロールの表示数
        myPageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
