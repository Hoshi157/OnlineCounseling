//
//  HistoryViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistoryViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let sidemenuVC = SidemenuViewController()
    weak var sidemenuDelegate: SidemenuViewControllerDelegate?
    
    override func viewDidLoad() {
        
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 1
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        self.title = "履歴"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25").withRenderingMode(.alwaysTemplate), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(sidemenuButtonAction))
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let bookmarkVC = self.storyboard?.instantiateViewController(identifier: "BookmarkHistory")
        let tellHistoryVC = self.storyboard?.instantiateViewController(identifier: "TellHistory")
        let childViewControllers = [bookmarkVC!, tellHistoryVC!]
        
        return childViewControllers
    }
    
    @objc func sidemenuButtonAction() {
        self.sidemenuDelegate?.sidemenuViewControllerDidRequestShowing(sidemenuVC, contentAvailability: true, animeted: true)
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
