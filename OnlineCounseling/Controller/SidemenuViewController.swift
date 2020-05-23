//
//  SidemenuViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit

class SidemenuViewController: UIViewController {
    
    lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    weak var delegate: SidemenuViewControllerDelegate?
    private let contentView = UIView(frame: .zero)
       private var contentMaxWidth: CGFloat {
           return view.bounds.width * 0.8
       }
    private var contentRatio: CGFloat {
        get{
            return contentView.frame.maxX / contentMaxWidth
        }
        set{
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    var isShow: Bool {
        return parent != nil
    }
    private var beganState: Bool = false
    private var beganLocation: CGPoint = .zero
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!

    lazy var avaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 30, y: 50, width: 60, height: 60)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageViewAction(_:))))
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    private var bookmarkIntLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "11"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let bookmarkStrLabel: UILabel = {
       let label = UILabel()
        label.text = "お気に入り"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        tableview.rowHeight = 50
        tableview.register(UINib(nibName: "SidemenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    private let tableArray: [String] = ["マイページ", "カウンセラーログイン"]
    private let tableImageArray: [UIImage] = [#imageLiteral(resourceName: "icons8-性中立ユーザー-25"), #imageLiteral(resourceName: "icons8-カウンセラー-25")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        contentView.addSubview(avaterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bookmarkIntLabel)
        contentView.addSubview(bookmarkStrLabel)
        contentView.addSubview(tableView)
        tableView.reloadData()
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avaterImageView.snp.bottom).offset(10)
            make.left.equalTo(avaterImageView)
        }
        
        bookmarkIntLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.equalTo(avaterImageView)
        }
        
        bookmarkStrLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookmarkIntLabel)
            make.left.equalTo(bookmarkIntLabel.snp.right).offset(10)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(bookmarkIntLabel.snp.bottom).offset(20)
            make.left.equalTo(avaterImageView)
            make.height.equalTo(100)
            make.width.equalTo(contentView.frame.width * 0.8)
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)

        
        // Do any additional setup after loading the view.
    }
    
    @objc func backViewTapped(_ sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: self)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    @objc func myPageViewAction(_ sender: UITapGestureRecognizer) {
        let mypageVC = storyBoard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
        let naviController = UINavigationController(rootViewController: mypageVC)
        naviController.modalPresentationStyle = .fullScreen
        self.present(naviController, animated: true)
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        }else {
            contentRatio = 1.0
        }
    }
    
    func hideContentView(animated: Bool, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        }else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    func startPanGestureRecognizing() {
        print("startPan")
        if let parentViewController = self.delegate?.parentViewControllerForSidemenuViewController(self) {
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
            
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
        }
    }
    
    @objc private func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard  let shouldPresent = self.delegate?.shouldPresentSidemenuViewController(self), shouldPresent else {
            return
        }
        let translation = panGestureRecognizer.translation(in: view)
        if translation.x > 0 && contentRatio == 1.0 {
            return
        }
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShow
            beganLocation = location
            if translation.x >= 0 {
                if let parent = self.parent {
                    self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animeted: false, currentViewController: parent)
                }
            }
        case .changed:
            let distance = beganState ? beganLocation.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
        case .ended, .cancelled, .failed:
            if contentRatio >= 1.0, contentRatio <= 0 {
                if location.x > beganLocation.x {
                    showContentView(animated: true)
                }else {
                    self.delegate?.sidemenuViewControllerDidRequestHiding(self, animeted: true)
                }
            }
            beganLocation = .zero
            beganState = false
        default: break
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

protocol SidemenuViewControllerDelegate: class {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController
    func shouldPresentSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animeted: Bool,currentViewController: UIViewController)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animeted: Bool)
    func sidemenuViewcontroller(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath)
}

extension SidemenuViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecogizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecogizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}

extension SidemenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuCell", for: indexPath) as! SidemenuTableViewCell
        cell.tableLabel.text = tableArray[indexPath.row]
        let image: UIImage = tableImageArray[indexPath.row].withRenderingMode(.alwaysTemplate)
        cell.iconImageView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        switch (indexPath.row) {
        case 0:
            let mypageVC = storyBoard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
            let naviController = UINavigationController(rootViewController: mypageVC)
            naviController.modalPresentationStyle = .fullScreen
            self.present(naviController, animated: true)
        case 1:
            print("カウンセラーページへ")
        default:
            print("error")
            return
        }
    }
    
}
