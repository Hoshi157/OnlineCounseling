//
//  HomeViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    // インスタンスを持つ
    let sidemenuVC = SidemenuViewController()
    weak var sidemenuDelegate: SidemenuViewControllerDelegate?
    // コレクションセルに表示するデータ配列
    private var collectionArray = [GetCollections]()
    private let userDB = Firestore.firestore().collection("users")
    // Realm
    private var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)]
        self.title = "ホーム"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-メニュー-25").withRenderingMode(.alwaysTemplate), landscapeImagePhone: #imageLiteral(resourceName: "icons8-メニュー-25").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(sidemenuButtonAction))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        collectionView.collectionViewLayout = layout
        
        // 取得したtypeを元にFirebaseからデータ取得
        self.gettypeToLocaldata(completion: { (type) in
            if (type != nil) {
                switch (type) { // 自分とtypeと逆のデータを取得
                case "user":
                    getData(type: "counselor")
                case "counselor":
                    getData(type: "user")
                default:
                    print("typeを取得できません")
                }
            }
        })
    }
    
    // 左上部のボタンが押されたらスライドメニューが開く
    @objc func sidemenuButtonAction() {
        self.sidemenuDelegate?.sidemenuViewControllerDidRequestShowing(sidemenuVC, contentAvailability: true, animeted: true)
    }
    // Cellのデータを取得
    func getData(type: String) {
        // リスナーにする事で変化に対応(現在はカウンセラーがいないためUser情報)
        userDB.whereField("type", isEqualTo: type).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error, "HomeVC error")
            }else {
                self.collectionArray = []
                for document in querySnapshot!.documents {
                    let name = document.data()["name"] as! String
                    let jobs = document.data()["jobs"] as! String
                    let uid = document.documentID
                    let getCollection = GetCollections(name: name, jobs: jobs, uid: uid)
                    self.collectionArray.append(getCollection)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    // Realmから自分のtypeを取得
    func gettypeToLocaldata(completion: (_ type: String?) -> Void) {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let type = user.type
            completion(type)
        }catch {
            print(error.localizedDescription, "error Realm")
            completion(nil)
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! CustomCollectionViewCell
        cell.nameLabel.text = collectionArray[indexPath.row].name
        cell.jobsLabel.text = collectionArray[indexPath.row].jobs
        let uid = collectionArray[indexPath.row].uid
        let filePath = self.fileInDocumentsDirectory(filename: uid!)
        let image = self.loadImageFromPath(path: filePath)
        cell.avaterImageView.layer.cornerRadius = 10
        cell.avaterImageView.clipsToBounds = true
        DispatchQueue.main.async {
            if (image != nil) {
                cell.avaterImageView.image = image
            }else {
                cell.avaterImageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_640-e1542530002984")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userByTappedVC = UserByTappedContenerViewController()
        // uidとNameを渡す
        userByTappedVC.userTapUid = self.collectionArray[indexPath.row].uid
        userByTappedVC.otherName = self.collectionArray[indexPath.row].name
        userByTappedVC.modalPresentationStyle = .fullScreen
        self.present(userByTappedVC, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 12
        let cellWidth = self.view.bounds.width / 2 - margin
        let cellHeight: CGFloat = 250
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
extension HomeViewController: imageSaveProtocol {}
