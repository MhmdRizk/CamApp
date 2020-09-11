//
//  DisplayViewController.swift
//  CamApp
//
//  Created by Mhmd Rizk on 9/11/20.
//  Copyright © 2020 Mhmd Rizk. All rights reserved.
//

import UIKit
import Photos
import AVKit

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var buttonsContainer: UIView!
    
    @IBOutlet weak var discardButton: UIButton!{
        didSet{
            discardButton.setTitle("Discard", for: .normal)
            discardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            discardButton.setTitleColor(.black, for: .normal)
            discardButton.backgroundColor = .clear
            discardButton.addTarget(self, action: #selector(self.discardPhoto), for: .touchUpInside)

        }
    }
    
    @IBOutlet weak var downloadButton: UIButton!{
        didSet{
            downloadButton.setTitle("Save", for: .normal)
            downloadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            downloadButton.setTitleColor(.black, for: .normal)
            downloadButton.backgroundColor = .clear
            downloadButton.addTarget(self, action: #selector(self.saveMedia), for: .touchUpInside)

        }
    }
    
    @IBOutlet weak var playIconImage: UIImageView!{
        didSet{
            if self.videoURL != nil {
                self.playIconImage.isHidden = false
            }else{
                self.playIconImage.isHidden = true
            }
            playIconImage.isUserInteractionEnabled = true
            let playIconTapGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(self.playIconTapped))
            playIconTapGesture.numberOfTapsRequired = 1
            playIconImage.addGestureRecognizer(playIconTapGesture)

        }
    }
    
    public var imageData : Data?
    
    public var videoURL : URL?
    
    
}

extension DisplayViewController{
    
    fileprivate func configureDisplay(){
        
        func displayImage(){
            guard let imageData = self.imageData else { return }
            self.displayImage.image = UIImage(data: imageData)
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
            }
        }
        
        func displayVideo(){
            guard let videoURL = self.videoURL else { return }
            videoURL.getThumbnailImageFromVideoUrl { (image) in
                if let image = image {
                    self.displayImage.image = image
                }
                
            }
        }
        
        displayImage()
        displayVideo()
        
    }
    
}

//MARK:- View Lifecycle
extension DisplayViewController{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}



//MARK:- Callbacks
extension DisplayViewController{
    

    
    @objc func playIconTapped(){
        guard let videoURL = self.videoURL else { return }
        let avplayer = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = avplayer
        self.present(playerController, animated: true) {
            playerController.player?.play()
        }
    }
    
    @objc func saveMedia(){
        if self.imageData != nil {
            self.savePhoto()
            return
        }
        
        if self.videoURL != nil {
            self.saveVideo()
            return
        }
    }
    
    @objc func saveVideo(){
        UISaveVideoAtPathToSavedPhotosAlbum(self.videoURL!.path,
                                            nil,
                                            nil,
                                            nil)
    }
    
    @objc func savePhoto(){
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo,
                                        data: self.imageData!,
                                        options: nil)
        }) { (success, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard success else { return }
            print("Photo saved to your library")
            self.dismiss(animated: true)
        }
    }
    
    @objc func discardPhoto(){
        self.dismiss(animated: true)
    }
    
}


