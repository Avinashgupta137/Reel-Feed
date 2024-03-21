//
//  CollectionViewCell.swift
//  Reels
//
//  Created by avinash on 19/03/24.
//

import UIKit
import GSPlayer

class CollectionViewCell: UICollectionViewCell {
    
    
    var videos:String!
    
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var PlayImg: UIImageView!
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
        playerView.addSubview(PlayImg)
        PlayImg.isHidden = true
    }
    func play(){
        showIndicator()
        playerView.play(for: URL(string: videos)!)
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.stopIndicator()
        }
    }
    func pause(){
        playerView.pause(reason: .hidden)
        
    }
    func viewSetup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.playerView.isUserInteractionEnabled = true
        self.playerView.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped(){
        if playerView.state == .playing {
            playerView.pause(reason: .userInteraction)
            PlayImg.isHidden = false
            PlayImg.image = UIImage(systemName: "pause.fill")
        }else {
            PlayImg.image = UIImage(systemName: "play.fill")
            playerView.resume()
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.PlayImg.isHidden = true
            }
        }
    }
    
    private func showIndicator(){
        playerView.addSubview(activityIndicator)
        // Add constraints to center it in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])
        // Start animating
        activityIndicator.startAnimating()
    }
    
    private func stopIndicator(){
        activityIndicator.stopAnimating()
    }
    
}
