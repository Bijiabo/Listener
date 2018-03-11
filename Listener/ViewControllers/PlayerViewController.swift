//
//  PlayerViewController.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import UIKit
import AVKit

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
    var currentPlayIndex: Int = 0
    var targetPlayIndex: Int = 0
    var currentTrack = 0
    var rate: Float = 1.0
    
    var touch_startLocation: CGPoint = CGPoint.zero
    var touch_endLocation: CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupPlayer()
        startPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(closePlayerPanel))
        
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
        
        controlGesture.delegate = self
    }
    
    private func updateDisplay() {
        title = ContentHelper.sharedInstance.convertPathToFolderName(path: playList[currentTrack].path)
        titleLabel.text = title
        rateLabel.text = "\(rate)"
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
    
    // custom gesture
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        nextTrack()
    }
    
    @IBAction func handleSwipe_Left(_ sender: UISwipeGestureRecognizer) {
        previousTrack()
    }
    
    
    @IBAction func handleSwipe_Up(_ sender: UISwipeGestureRecognizer) {
        upRate()
        
    }
    
    @IBAction func handleSwipe_Down(_ sender: UISwipeGestureRecognizer) {
        downRate()
    }
    
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        if player.rate > 0 {
            player.pause()
        } else {
            player.play()
        }
    }
    
    // player functions
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
        for touch in touches {
            let location = touch.location(in: self.view)
            touchHandleMark.frame = CGRect(x: location.x-22, y: location.y-22, width: 44, height: 44)
            print(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.view)
            touchHandleMark.frame = CGRect(x: location.x-22, y: location.y-22, width: 44, height: 44)
            print(location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(touches.count)
    }
}
