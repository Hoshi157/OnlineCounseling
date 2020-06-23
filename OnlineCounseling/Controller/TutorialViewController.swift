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
import UserNotifications
// ウォークスルー画面
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
        pagecontrol.currentPageIndicatorTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // 選択時
        return pagecontrol
    }()
    // ウォークスルーNibを3つ用意
    lazy var welcomeView: WelcomeView = {
        let welView = WelcomeView()
        welView.frame = self.view.frame
        return welView
    }()
    
    lazy var explanatinView: UIView = {
        let expView = ExplanationView()
        return expView
    }()
    
    lazy var reservationExplatinView: ReservationExplanationView = {
        let reserView = ReservationExplanationView()
        return reserView
    }()
    
    lazy var toggleButton: MDCFloatingButton = {
        let button = MDCFloatingButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setBorderWidth(3, for: .normal)
        button.setBorderColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextOrStartAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSizeWidth = screenSize.width
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(myScrollView)
        view.addSubview(myPageControl)
        view.addSubview(toggleButton)
        myScrollView.addSubview(welcomeView)
        myScrollView.addSubview(explanatinView)
        myScrollView.addSubview(reservationExplatinView)
        
        myPageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-50)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        explanatinView.snp.makeConstraints { (make) in
            make.centerX.equalTo(myScrollView).offset(screenSizeWidth!)
            make.centerY.equalTo(myScrollView)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        reservationExplatinView.snp.makeConstraints { (make) in
            make.centerX.equalTo(myScrollView).offset(screenSizeWidth! * 2)
            make.bottom.equalTo(self.view)
            make.centerY.equalTo(myScrollView)
            make.width.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
        toggleButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(myPageControl.snp.top).offset(-20)
        }
        toggleButtonImageset(page: 1)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func nextOrStartAction() {
        let page = myPageControl.currentPage + 1
        if (page <= 2) {
        scrollPage(page: page, animated: true)
        }else {
            let loginSelectonVC = LoginSelectionViewController()
            let navi = UINavigationController(rootViewController: loginSelectonVC)
            navi.modalPresentationStyle = .fullScreen
            present(navi, animated: true)
            self.localNotigicationModal()
        }
    }
    
    func scrollPage(page: Int, animated: Bool) {
        var fram = myScrollView.bounds
        fram.origin.x = fram.size.width * CGFloat(page)
        DispatchQueue.main.async {
            self.myScrollView.scrollRectToVisible(fram, animated: animated)
        }
    }
    
    func toggleButtonImageset(page: Int) {
        if (page <= 1) {
            let image = #imageLiteral(resourceName: "icons8-右の並べ替え-25").withRenderingMode(.alwaysTemplate)
            DispatchQueue.main.async {
                self.toggleButton.setTitle(String(), for: .normal)
                self.toggleButton.setImage(image, for: .normal)
                self.toggleButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.toggleButton.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }else {
            DispatchQueue.main.async {
                self.toggleButton.setImage(UIImage(), for: .normal)
                self.toggleButton.setTitle("Start", for: .normal)
                self.toggleButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                self.toggleButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    // ローカル通知の許可
    func localNotigicationModal() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if let error = error {
                    print(error.localizedDescription, "error　ローカルプッシュ")
                }else {
                    if (granted) {
                        print("通知許可")
                        let center = UNUserNotificationCenter.current()
                        center.delegate = self
                    }else {
                        print("通知不可")
                    }
                }
            })
        }else {
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
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

extension TutorialViewController: UIScrollViewDelegate {
    //　スクロールした後
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロールビューをx方向に移動した分 / フレームワイド = ページコントロールの表示数
        myPageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let page = myPageControl.currentPage
        self.toggleButtonImageset(page: page)
    }
}
// アプリ起動時にも通知する
extension TutorialViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}
