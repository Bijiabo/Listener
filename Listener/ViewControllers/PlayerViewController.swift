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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
