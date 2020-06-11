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

// ビデオチャット画面
class ConnectViewController: UIViewController {
    
    // Skyway
    private let apikey: String = "" // apiは消す!!!!!!!!!!!!!!!
    private let domain: String = "localhost"
    private var peer: SKWPeer!
    private var localStream: SKWMediaStream?
    private var remoteStream: SKWMediaStream?
    private var mediaConnection: SKWMediaConnection?
    var connectLocalVideo = SKWVideo() // 自分のVideoView
    var connectRemoteVideo = SKWVideo() // 相手のVideoView
    private var sfuRoom: SKWSFURoom?
    
    var otherName: String?
    var otherUid: String?
    
    private var realm: Realm!
    
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
            make.top.equalTo(50)
            make.right.equalTo(self.connectRemoteVideo)
        }
        
        self.setup()
        self.joinRoom()
        

        // Do any additional setup after loading the view.
    }
    // 離れる時
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.peer.destroy()
        DispatchQueue.main.async {
            self.mediaConnection?.close()
        }
    }
    // 終了時
    @objc func tapConnectEnd() {
        DispatchQueue.main.async {
            self.mediaConnection?.close()
        }   
    }
    
    @objc func backViewAction() {
        dismiss(animated: true, completion: nil)
    }
    // RoomIdはカウンセラーのuid
    func getRoomId() -> String? {
        do {
            realm = try Realm()
            let user = realm.objects(User.self).last!
            let type = user.type
            if (type == "user") {
                return self.otherUid
            }else {
                return user.uid
            }
        }catch {
            print(error.localizedDescription, "error Realm")
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
    // roomを作成
    func joinRoom() {
        guard let roomId = getRoomId() else {
            print(getRoomId() ?? "nil", "getroomがnil")
            return
        }
        
            let option = SKWRoomOption.init()
            option.mode = .ROOM_MODE_SFU
            option.stream = self.localStream
            sfuRoom = peer.joinRoom(withName: roomId, options: option) as? SKWSFURoom
            
            sfuRoom?.on(.ROOM_EVENT_OPEN, callback: { (obj) in
                
            })
            
            sfuRoom?.on(.ROOM_EVENT_CLOSE, callback: { (obj) in
                if let _sfuRoom = self.sfuRoom {
                    _sfuRoom.offAll()
                    self.sfuRoom = nil
                }
            })
    }
    
    func setupStream(peer: SKWPeer) {
        SKWNavigator.initialize(peer);
        let constarants = SKWMediaConstraints()
        self.localStream = SKWNavigator.getUserMedia(constarants)
        self.localStream?.addVideoRenderer(self.connectLocalVideo, track: 0)
    }
    
    func call(targetPeerId: String) {
        let option = SKWCallOption()
        
        if let mediaConnection = self.peer.call(withId: targetPeerId, stream: self.localStream, options: option) {
            self.mediaConnection = mediaConnection
            self.setupMediaConnectionCallBacks(mediaConnection: mediaConnection)
        }else {
            print(targetPeerId, "failed to call")
        }
    }
}

extension ConnectViewController {
    // イベント
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
            }
        })
        // 接続
        peer.on(.PEER_EVENT_CALL, callback: { (obj) in
            print("peer call")
            
            if let connection = obj as? SKWMediaConnection {
                self.setupMediaConnectionCallBacks(mediaConnection: connection)
                self.mediaConnection = connection
                connection.answer(self.localStream)
            }
        })
    }
    
    func setupMediaConnectionCallBacks(mediaConnection: SKWMediaConnection) {
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
    
}


