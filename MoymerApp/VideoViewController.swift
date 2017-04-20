//
//  VideoViewController.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class VideoViewController: UIViewController {

    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var imageBackground = UIImageView()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.image = informationsDAO.sharedInstance.getVideoInfo(index: informationsDAO.sharedInstance.getCellSelected()).getThumb()
        imageBackground.frame = self.view.bounds
        self.view.addSubview(imageBackground)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.imageBackground.alpha = 0
        player.play()
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        player.pause()
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    func loadVideo(videoUrl : String!){
        let url = URL(string: videoUrl)
        self.player = AVPlayer(url: url!)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        
        
    }
    
    func loadBackground(thumb : UIImage){
        self.imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.imageBackground.image = thumb
        self.imageBackground.contentMode = .scaleAspectFill
        self.view.addSubview(self.imageBackground)
    }
    
    func playVideo() {
        player.play()
    }

    func addtitle(text: String!, rect : CGRect){
        let label = UILabel(frame: rect)
        
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        label.font = titleLabel.font.withSize(40)
        //label.font = label.font.familyName
        
        self.view.addSubview(label)
    }
    
    

}
