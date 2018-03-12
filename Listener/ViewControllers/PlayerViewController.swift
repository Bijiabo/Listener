//
//  PlayerViewController.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerViewController: UIViewController {
    
    // UI components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlGesture: ControlGestureRecognizer!
    @IBOutlet weak var rateLabel: UILabel!
    var touchHandleMark: UIView = UIView()
    
    var contentTitle: String = ""
    let playButton = UIButton()
    var playList: [URL] = [URL]()
    var playerItems: [AVPlayerItem] = [AVPlayerItem]()
    var player: AVQueuePlayer = AVQueuePlayer(items: [AVPlayerItem]())
    var targetPlayIndex: Int = 0
    var currentTrack = 0
    var rate: Float = 1.0
    
    var touch_startLocation: CGPoint = CGPoint.zero
    var touch_endLocation: CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBackgroundPlaySession()
        setupPlayer()
        startPlay()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        // add notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSelectPlayListNotification(sender:)), name: NotificationHelper.sharedInstance.notification_selectPlayList, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateDisplay()
    }
    
    @objc func didReceiveSelectPlayListNotification(sender: Notification) {
        guard let object = sender.object as? [String: Any] else {return}
        guard
        let _playList = object["playList"] as? [URL],
        let _targetPlayIndex = object["targetPlayIndex"] as? Int
            else {return}
        
        self.playList = _playList
        self.targetPlayIndex = _targetPlayIndex
        
        setupPlayer()
        startPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        
        title = "Play View"
        view.backgroundColor = UIColor.white
        /*
        playButton.setTitle("Play Button", for: UIControlState.normal)
        playButton.addTarget(self, action: #selector(tapPlayButton), for: UIControlEvents.touchUpInside)
        view.addSubview(playButton)
        */
        titleLabel.text = contentTitle
        touchHandleMark.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        touchHandleMark.backgroundColor = UIColor.blue
        view.addSubview(touchHandleMark)
        touchHandleMark.isHidden = true
        
        controlGesture.delegate = self
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PlayList", style: UIBarButtonItemStyle.done, target: self, action: #selector(pickPlayList))
    }
    
    @objc func pickPlayList() {
        let defaultNavigationController = UINavigationController()
        let rootViewController: UIViewController = FolderViewController()
        defaultNavigationController.viewControllers = [rootViewController]
        defaultNavigationController.view.backgroundColor = UIColor.white
        
        self.present(defaultNavigationController, animated: true, completion: nil)
    }
    
    private func updateDisplay() {
        if playList.count == 0 {return}
        
        title = ContentHelper.sharedInstance.convertPathToFolderName(path: playList[currentTrack].path)
        titleLabel.text = title
        rateLabel.text = "\(rate)"
        setBackgroundPlayInformation()
    }
    
    @objc func tapPlayButton() {
        
    }
    
    @objc func closePlayerPanel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupPlayer() {
        playerItems = self.playList.map { (playListItem: URL) -> AVPlayerItem in
            return AVPlayerItem(url: playListItem)
        }
        player = AVQueuePlayer(items: playerItems)
    }
    
    private func startPlay() {
        playAt(index: targetPlayIndex)
    }
    
    // player functions
    func togglePlayPause() {
        if player.rate > 0 {
            player.pause()
        } else {
            player.play()
        }
        updateDisplay()
    }
    
    
    func previousTrack() {
        if currentTrack - 1 < 0 {
            currentTrack = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
        } else {
            currentTrack -= 1
        }
        
        playTrack()
    }
    
    func nextTrack() {
        if currentTrack + 1 >= playerItems.count {
            currentTrack = 0
        } else {
            currentTrack += 1;
        }
        
        playTrack()
    }
    
    func playTrack() {
        if playerItems.count > 0 {
            playAt(index: currentTrack)
        }
    }
    
    func playAt(index: Int) {
        print(index)
        player.pause()
        setupPlayer()
        for (_index, _) in player.items().enumerated() {
            if _index < index {
                player.advanceToNextItem()
            } else {
                player.play()
                player.rate = rate
                break
            }
        }
        currentTrack = index
        updateDisplay()
    }
    
    func upRate() {
        player.rate += 0.2
        rate = player.rate
        updateDisplay()
        
        print(player.rate)
    }
    
    func downRate() {
        if player.rate <= 0.2 {return}
        player.rate -= 0.2
        rate = player.rate
        updateDisplay()
        
        print(player.rate)
    }
    
    func setupBackgroundPlaySession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
    }
    
    func setBackgroundPlayInformation() {
        
        let itemArtwork = MPMediaItemArtwork(boundsSize: CGSize(width: 200, height: 200)) { (size: CGSize) -> UIImage in
            return UIImage()
        }
        let settings = [MPMediaItemPropertyTitle: "大标题",
                        MPMediaItemPropertyArtist: "小标题",
                        MPMediaItemPropertyPlaybackDuration: "\(player.currentItem?.duration)",
            MPNowPlayingInfoPropertyElapsedPlaybackTime: "\(player.currentTime)",
            MPMediaItemPropertyArtwork: itemArtwork,
            ] as [String : Any]
        
            MPNowPlayingInfoCenter.default().setValue(settings, forKey: "nowPlayingInfo")
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {return}
        switch event.type {
        case .remoteControl:
            switch event.subtype {
            case .remoteControlTogglePlayPause:
                togglePlayPause()
            case .remoteControlPlay:
                player.pause()
                updateDisplay()
            case .remoteControlPause:
                player.play()
                updateDisplay()
            default:
                break
            }
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayerViewController: UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(touches.count)
        touch_startLocation = touches.first!.location(in: self.view)
        touchHandleMark.isHidden = false
        touchHandleMark.frame = CGRect(x: touch_startLocation.x-22, y: touch_startLocation.y-22, width: 44, height: 44)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch_location = touches.first!.location(in: self.view)
        touchHandleMark.frame = CGRect(x: touch_location.x-22, y: touch_location.y-22, width: 44, height: 44)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandleMark.isHidden = true
        
        touch_endLocation = touches.first!.location(in: self.view)
        
        let x_distance = touch_endLocation.x - touch_startLocation.x
        let y_distance = touch_endLocation.y - touch_startLocation.y
        
        if x_distance == 0 && y_distance == 0 {
            togglePlayPause()
            return
        }
        
        if fabs(x_distance) > fabs(y_distance) {
            // swipe left or right
            if x_distance > 0 {
                nextTrack()
            } else {
                previousTrack()
            }
        } else {
            // swipe up or down
            if y_distance > 0 {
                downRate()
            } else {
                upRate()
            }
        }
        
//        print(touches.count)
    }
    
    
}
