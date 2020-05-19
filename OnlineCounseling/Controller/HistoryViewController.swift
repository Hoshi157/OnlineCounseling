//
//  HistoryViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SnapKit

class HistoryViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.09708004216, green: 0.7204460874, blue: 1, alpha: 1)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 2
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "履歴"
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let bookmarkVC = self.storyboard?.instantiateViewController(identifier: "BookmarkHistory")
        let tellHistoryVC = self.storyboard?.instantiateViewController(identifier: "TellHistory")
        let childViewControllers = [bookmarkVC!, tellHistoryVC!]
        
        return childViewControllers
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
