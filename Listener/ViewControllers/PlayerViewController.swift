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
    
    let playButton = UIButton()
    var playList: [URL] = [URL]()
    var playerItems: [AVPlayerItem] = [AVPlayerItem]()
    var player: AVQueuePlayer = AVQueuePlayer(items: [AVPlayerItem]())
    var currentPlayIndex: Int = 0
    var targetPlayIndex: Int = 0

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
        
        playButton.setTitle("Play Button", for: UIControlState.normal)
        playButton.addTarget(self, action: #selector(tapPlayButton), for: UIControlEvents.touchUpInside)
        view.addSubview(playButton)
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
        player.play()
        // guard let currentPlayItem = player.currentItem else {return}
        // var currentIndex = player.items().index(of: currentPlayItem)
        for (index, item) in player.items().enumerated() {
            if index < targetPlayIndex {
                player.advanceToNextItem()
            } else {
                player.play()
                break
            }
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
