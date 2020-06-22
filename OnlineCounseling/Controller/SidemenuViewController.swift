//
//  SidemenuViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import MaterialComponents

class SidemenuViewController: UIViewController {
    
    private var accountcreateFlg: Bool! // アカウント作成しているか
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
            contentView.layer.shadowColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
            contentView.layer.shadowRadius = 0.8
            view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.2 * ratio)
        }
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    var isShow: Bool {
        return parent != nil
    }
    private var beganState: Bool = false
    private var beganLocation: CGPoint = .zero
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    // Realm
    private var realm: Realm!
    private var photoImage: UIImage?
    private var name: String?
    private var bookmarkCount: String?
    
    lazy var avaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 30, y: 50, width: 60, height: 60)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageViewAction(_:))))
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
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
        tableview.separatorStyle = .none
        return tableview
    }()
    
    private let accountcreateLabel: UILabel = {
        let label = UILabel()
        label.text = "アカウントを作成してカウンセリングしましょう。"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var accountcreateButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        button.setTitle("アカウント作成", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(accountcreateTransition), for: .touchUpInside)
        return button
    }()
    
    private let accountTakeoverLabel: UILabel = {
        let label = UILabel()
        label.text = "メールアドレス・パスワードを登録するとアプリを削除してもデータを引き継ぐことができます"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var accountTakeoverButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("アカウント引き継ぎ", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setBorderWidth(1, for: .normal)
        button.setBorderColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(accountTakeoverTransition), for: .touchUpInside)
        return button
    }()
    
    
    private let tableArray: [String] = ["マイページ", "カウンセラーログイン"]
    private let tableImageArray: [UIImage] = [#imageLiteral(resourceName: "icons8-性中立ユーザー-25"), #imageLiteral(resourceName: "icons8-カウンセラー-25")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
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
        
        displayAccountcreateWidget()
        displayAccountTakeoverWidget()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.dataDisplay()
        getAccountcreateFlg()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("スライドメニュー")
        super.viewWillAppear(animated)
        print("スライドメニュー willApper")
    }
    
    func dataDisplay() {
        // データの取り出し
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            print(user, "user")
            try realm.write {
                self.name = user.name
                self.bookmarkCount = "\(user.bookmarks.count)"
                let image = loadImageFromPath(path: user.imagePath)
                self.photoImage = image
            }
        }catch {
            print("error")
        }
        // データを表示
        if (self.name != "") {
            nameLabel.text = self.name!
        }else {
            nameLabel.text = "ゲストさん"
        }
        if (self.photoImage != nil) {
            DispatchQueue.main.async {
                self.avaterImageView.image = self.photoImage
            }
        }else {
            DispatchQueue.main.async {
                self.avaterImageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
            }
        }
        bookmarkIntLabel.text = self.bookmarkCount
    }
    
    @objc func backViewTapped(_ sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: self)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    @objc func myPageViewAction(_ sender: UITapGestureRecognizer) {
        if (self.accountcreateFlg == true) {
            let mypageVC = storyBoard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
            let navi = UINavigationController(rootViewController: mypageVC)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }else {
            let accountCreateVC = self.storyBoard.instantiateViewController(withIdentifier: "accountCreateVC") as! AccountCreateViewController
            let navi = UINavigationController(rootViewController: accountCreateVC)
            navi.modalPresentationStyle = .fullScreen
            present(navi, animated: true)
        }
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
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
                self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animeted: false)
            }
        case .changed:
            let distance = beganState ? beganLocation.x - location.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
        case .ended, .cancelled, .failed:
            if contentRatio <= 1.0, contentRatio >= 0 {
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
    
    func getAccountcreateFlg() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            self.accountcreateFlg = user.accountCreateFlg
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    // アカウント作成ウィジット
    func displayAccountcreateWidget() {
        contentView.addSubview(accountcreateLabel)
        contentView.addSubview(accountcreateButton)
        
        accountcreateLabel.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.frame.width * 0.8)
            make.top.equalTo(tableView.snp.bottom).offset(50)
            make.left.equalTo(contentView).offset(10)
        }
        
        accountcreateButton.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.frame.width * 0.8)
            make.top.equalTo(accountcreateLabel.snp.bottom).offset(10)
            make.left.equalTo(accountcreateLabel)
            make.height.equalTo(40)
        }
    }
    
    func displayAccountTakeoverWidget() {
        contentView.addSubview(accountTakeoverLabel)
        contentView.addSubview(accountTakeoverButton)
        
        accountTakeoverLabel.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.frame.width * 0.8)
            make.top.equalTo(accountcreateButton.snp.bottom).offset(30)
            make.left.equalTo(contentView).offset(10)
        }
        
        accountTakeoverButton.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.frame.width * 0.8)
            make.top.equalTo(accountTakeoverLabel.snp.bottom).offset(10)
            make.left.equalTo(accountTakeoverLabel)
            make.height.equalTo(40)
        }
    }
    
    @objc func accountcreateTransition() {
        let accountCreateVC = self.storyBoard.instantiateViewController(withIdentifier: "accountCreateVC") as! AccountCreateViewController
        let navi = UINavigationController(rootViewController: accountCreateVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
    @objc func accountTakeoverTransition() {
        let accountTakeoverVC = self.storyBoard.instantiateViewController(withIdentifier: "accountTakeVC") as! AccountTakeoverViewController
        let navi = UINavigationController(rootViewController: accountTakeoverVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
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
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animeted: Bool)
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
        switch (indexPath.row) {
        case 0:
            if (self.accountcreateFlg == true) {
                let mypageVC = storyBoard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
                let navi = UINavigationController(rootViewController: mypageVC)
                navi.modalPresentationStyle = .fullScreen
                self.present(navi, animated: true)
            }else {
                let accountCreateVC = self.storyBoard.instantiateViewController(withIdentifier: "accountCreateVC") as! AccountCreateViewController
                let navi = UINavigationController(rootViewController: accountCreateVC)
                navi.modalPresentationStyle = .fullScreen
                present(navi, animated: true)
            }
        case 1:
            let counselorRoginVC: UIViewController = CounselorRoginViewController()
            let navi = UINavigationController(rootViewController: counselorRoginVC)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        default:
            print("error")
            return
        }
    }
}

extension SidemenuViewController: imageSaveProtocol {}
