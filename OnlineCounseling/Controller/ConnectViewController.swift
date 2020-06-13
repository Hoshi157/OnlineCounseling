//
//  ConnectViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/11.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SkyWay
import MaterialComponents
import SnapKit
import AVFoundation
import RealmSwift
import Firebase

// ビデオチャット画面
class ConnectViewController: UIViewController {
    
    // Skyway
    private let apikey: String = "8ffb8987-872d-4c6b-bd87-4b7e1067607a" // apiは消す!!!!!!!!!!!!!!!
    private let domain: String = "localhost"
    private var peer: SKWPeer!
    private var localStream: SKWMediaStream?
    private var remoteStream: SKWMediaStream?
    private var mediaConnection: SKWMediaConnection?
    var connectLocalVideo = SKWVideo() // 自分のVideoView
    var connectRemoteVideo = SKWVideo() // 相手のVideoView
    private var sfuRoom: SKWSFURoom?
    private var arrayMediaStreams: NSMutableArray = []
    private var arrayVideoViews: NSMutableDictionary = [:]
    
    var otherName: String?
    var otherUid: String?
    
    private var realm: Realm!
    private var uid: String?
    private let usersDB = Firestore.firestore().collection("users")
    
    lazy var connectEndButton: MDCFloatingButton = {
        let button = MDCFloatingButton()
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "icons8-通話を終了-25-2").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapConnectEnd), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), landscapeImagePhone: #imageLiteral(resourceName: "icons8-ダブル左-25").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backViewAction))
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        title = otherName
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).withAlphaComponent(0.3)
    
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(connectRemoteVideo)
        connectRemoteVideo.addSubview(connectLocalVideo)
        connectRemoteVideo.addSubview(connectEndButton)
        
        connectRemoteVideo.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        connectEndButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.connectRemoteVideo).offset(-50)
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        
        connectLocalVideo.snp.makeConstraints { (make) in
            make.size.equalTo(150)
            make.top.equalTo(self.connectRemoteVideo).offset(90)
            make.right.equalTo(self.connectRemoteVideo)
        }
        
        self.uid = getSelfuid()
        self.setup()
        

        // Do any additional setup after loading the view.
    }
    // 離れる時
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.peer.destroy()
        DispatchQueue.main.async {
            self.mediaConnection?.close()
            self.sfuRoom?.close()
        }
    }
    // 終了時
    @objc func tapConnectEnd() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // RoomIdはカウンセラーのuid+ユーザーId
    func getRoomId() -> String? {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let type = user.type
            if (type == "user") {
                let uid = user.uid
                let roomId = self.otherUid! + uid
                return roomId
            }else {
                let uid = user.uid
                let roomId = uid + self.otherUid!
                return roomId
            }
        }catch {
            print(error.localizedDescription, "error Realm")
            return nil
        }
    }
    // カウンセリング履歴をRealmへ保存
    func updataToLocaldata() {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            try realm.write {
                let counseling = CounselingHistory(value: ["uid": self.otherUid!, "name": self.otherName!])
                user.counselings.append(counseling)
            }
        }catch {
            print(error.localizedDescription, "error Realm")
        }
    }
    // カウンセリング履歴をFirebaseへ保存
    func updataToCloud(myUid: String) {
        usersDB.document(myUid).collection("counseling").addDocument(data: ["name": self.otherName!, "uid": self.otherUid!])
    }
    
    // 自分のuidを取得
    func getSelfuid() -> String? {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let uid = user.uid
            return uid
        }catch {
            print(error.localizedDescription, "error getUid")
            return nil
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


extension ConnectViewController {
    // peerオブジェクト作成
    func setup() {
        let option: SKWPeerOption = SKWPeerOption.init()
        option.key = self.apikey
        option.domain = self.domain
        
        peer = SKWPeer(options: option)
        if let _peer = peer {
            setupPeerCallBacks(peer: _peer)
            setupStream(peer: _peer)
        }else {
            print("faild to create peer setup")
        }
    }
    // 接続イベント
    func setupPeerCallBacks(peer: SKWPeer) {
        // エラー
        peer.on(.PEER_EVENT_ERROR, callback: { (obj) in
            if let error = obj as? SKWPeerError {
                print(error, "error")
            }
        })
        // オープン(サーバーと接続して準備できたら発火)
        peer.on(.PEER_EVENT_OPEN, callback: { (obj) in
            if let peerId = obj as? String {
                print(peerId, "your peerId")
                self.joinRoom() // ここでjoinroomしないとerror
            }
        })
    }
    // カメラ、音声のオプションを設定(MediaConnectionオブジェクト)
    func setupStream(peer: SKWPeer) {
        SKWNavigator.initialize(peer);
        let constarants = SKWMediaConstraints()
        constarants.cameraPosition = .CAMERA_POSITION_FRONT
        self.localStream = SKWNavigator.getUserMedia(constarants)
        self.localStream?.addVideoRenderer(self.connectLocalVideo, track: 0)
    }
}

extension ConnectViewController {
    //   カメラ、マイク処理のイベント(MediaConnectionイベント)
    func setupMediaConnectionCallBacks(mediaConnection: SKWMediaConnection) {
        // カメラ映像、音声を受信した時
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM, callback: { (obj) in
            self.remoteAudioSpeaker()
            
            if let msStream = obj as? SKWMediaStream {
                self.remoteStream = msStream
                DispatchQueue.main.async {
                    self.remoteStream?.addVideoRenderer(self.connectRemoteVideo, track: 0)
                }
            }
        })
        // 終了時
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE, callback: { (obj) in
            if let _ = obj as? SKWConnection {
                DispatchQueue.main.async {
                    self.remoteStream?.removeVideoRenderer(self.connectRemoteVideo, track: 0)
                    self.remoteStream = nil
                    self.mediaConnection = nil
                }
            }
        })
    }
    // 音をスピーカーに対応させる
    func remoteAudioSpeaker() {
        self.remoteStream?.setEnableAudioTrack(0, enable: true)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let audioSettion = AVAudioSession.sharedInstance()
            do {
                try audioSettion.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }catch {
                print(error.localizedDescription, "audio error")
            }
        }
    }
    
    // roomを作成
    func joinRoom() {
        print("join Room")
        guard let roomId = getRoomId() else {
            print(getRoomId() ?? "nil", "getroomId")
            return
        }
        
            let option = SKWRoomOption.init()
            option.mode = .ROOM_MODE_SFU
            option.stream = self.localStream
            sfuRoom = peer.joinRoom(withName: roomId, options: option) as? SKWSFURoom
            
        // 相手が入室した時
        sfuRoom?.on(.ROOM_EVENT_PEER_JOIN, callback: { (obj) in
            print("入室した")
            self.updataToLocaldata()
            self.updataToCloud(myUid: self.uid!)
        })
        
        sfuRoom?.on(.ROOM_EVENT_REMOVE_STREAM, callback: { (obj) in
            let mediaStream = obj as? SKWMediaStream
            let peerId = mediaStream?.peerId
            
            if let video = self.arrayVideoViews.object(forKey: peerId!) as? SKWVideo {
                mediaStream?.removeVideoRenderer(video, track:  0)
                video.removeFromSuperview()
                self.arrayVideoViews.removeObject(forKey: peerId!)
            }
            self.arrayVideoViews.removeObject(forKey: peerId!)
        })
        
        sfuRoom?.on(.ROOM_EVENT_STREAM, callback: { (obj) in
            let mediaStream = obj as! SKWMediaStream
            self.arrayMediaStreams.add(mediaStream)
        })
        
        // クローズ
        sfuRoom?.on(.ROOM_EVENT_CLOSE, callback: { (obj) in
            if let _sfuRoom = self.sfuRoom {
                _sfuRoom.offAll()
                self.sfuRoom = nil
            }
        })
        
    }
}


