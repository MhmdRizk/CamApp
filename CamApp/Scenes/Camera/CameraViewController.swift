//
//  CameraViewController.swift
//  CamApp
//
//  Created by Mhmd Rizk on 9/11/20.
//  Copyright © 2020 Mhmd Rizk. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CameraViewController: UIViewController {
    

    @IBOutlet weak var capturePreviewView: UIView!
    
    @IBOutlet weak var flashIconButton: UIImageView!{
        didSet{
            flashIconButton.isUserInteractionEnabled = true
            let flashIconTapGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(self.flashIconTapped))
            flashIconTapGesture.numberOfTapsRequired = 1
            flashIconButton.addGestureRecognizer(flashIconTapGesture)
        }
    }
    
    @IBOutlet weak var flashButtonsContainerView: UIView!
    
    @IBOutlet weak var autoFlashButton: UIButton!{
        didSet{
            autoFlashButton.setTitle("Auto", for: .normal)
            autoFlashButton.setTitleColor(.black, for: .normal)
            autoFlashButton.backgroundColor = .clear
            autoFlashButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            onFlashButton.addTarget(self, action: #selector(self.autoFlashIconTapped), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var onFlashButton: UIButton!{
        didSet{
            onFlashButton.setTitle("On", for: .normal)
            onFlashButton.setTitleColor(.black, for: .normal)
            onFlashButton.backgroundColor = .clear
            onFlashButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            onFlashButton.addTarget(self, action: #selector(self.onFlashIconTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var offFlashButton: UIButton!{
        didSet{
            offFlashButton.setTitle("Off", for: .normal)
            offFlashButton.setTitleColor(.black, for: .normal)
            offFlashButton.backgroundColor = .clear
            offFlashButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            offFlashButton.addTarget(self, action: #selector(self.offFlashIconTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var recordView: UIView!{
        didSet{
            recordView.layer.cornerRadius = recordView.frame.height/2
            recordView.clipsToBounds = true
            recordView.backgroundColor = .red
            recordView.isHidden = true
        }
    }
    
    @IBOutlet weak var recordTimerLabel: UILabel!{
        didSet{
            recordTimerLabel.text = "00:00"
            recordTimerLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
            recordTimerLabel.textColor = .black
            recordTimerLabel.textAlignment = .center
            recordTimerLabel.numberOfLines = 1
            recordTimerLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var switchPostionIcon: UIImageView!{
        didSet{
            switchPostionIcon.isUserInteractionEnabled = true
            let switchPositionTapGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(self.switchCamera))
            switchPositionTapGesture.numberOfTapsRequired = 1
            switchPostionIcon.addGestureRecognizer(switchPositionTapGesture)
        }
    }

    @IBOutlet weak var captureImageButton: UIImageView!{
        didSet{
            captureImageButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.captureImage))
            tapGesture.numberOfTapsRequired = 1
            self.captureImageButton.addGestureRecognizer(tapGesture)
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.recordVideo))
            self.captureImageButton.addGestureRecognizer(longGesture)
            
        }
    }
    
    fileprivate let cameraController = CameraController()
    
    fileprivate var isFlashOptionsVisible : Bool = false
    
    fileprivate var timerCount : TimeInterval?
    
    fileprivate weak var timer : Timer?

}


//MARK:- View Lifecycle
extension CameraViewController{
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        configureCameraController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        func hideFlash(){
            self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                         y: 0)
        }
        
        hideFlash()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
}



//MARK:- Flash
extension CameraViewController{
    
    @objc func flashIconTapped(){
       if self.isFlashOptionsVisible {
            UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
                self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                             y: 0)
            }
        }else{
            UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
                self.flashButtonsContainerView.transform = CGAffineTransform.identity
            }
        }
        self.isFlashOptionsVisible.toggle()
    }
    
    @objc func autoFlashIconTapped(){
        guard self.cameraController.flashMode != .auto else {
            UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
                self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                             y: 0)
            }
            return
        }
        self.cameraController.flashMode = .auto
        self.flashIconButton.image = UIImage(named : "MainFlashOnA")
        UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
            self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                         y: 0)
        }
        
    }
    
    @objc func onFlashIconTapped(){
        guard self.cameraController.flashMode != .on else {
            UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
                self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                             y: 0)
            }
            return
        }
        self.cameraController.flashMode = .on
        self.flashIconButton.image = UIImage(named : "MainFlashOn")
        UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
            self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                         y: 0)
        }
        
    }
    
    @objc func offFlashIconTapped(){
        guard self.cameraController.flashMode != .off else {
            UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
                self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                             y: 0)
            }
            return
        }
        self.cameraController.flashMode = .off
        self.flashIconButton.image = UIImage(named : "MainFlash")
        UIView.animate(withDuration: TimeInterval(floatLiteral: 0.4)) {
            self.flashButtonsContainerView.transform = CGAffineTransform(scaleX: 0,
                                                                         y: 0)
        }
        
    }
    
}


//MARK:- Switch Camera
extension CameraViewController{
    
    @objc func switchCamera(){
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
    }
    
}

//Capture Image & Record Video
extension CameraViewController{
    
    @objc func captureImage(tapRecognizer : UITapGestureRecognizer) {
        cameraController.captureImage {(imageData, error) in
            guard let image = imageData else {
                print(error ?? "Image capture error")
                return
            }
            self.displayCapturedImage(image)
        }
    }
    
    @objc func addLabelCounter(){
        if self.timerCount == nil { self.timerCount = 0 }
        self.timerCount! += 1
        let min = Int(self.timerCount! / 60)
        let sec = Int(self.timerCount!.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        print(totalTimeString)
        self.recordTimerLabel.text = totalTimeString
        
    }
    
    @objc func recordVideo(longGestureRecognizer : UILongPressGestureRecognizer) {
                
        if longGestureRecognizer.state == .began {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(self.addLabelCounter),
                                              userInfo: nil,
                                              repeats: true)
            
            
            
            cameraController.recordVideo { (_,_) in }
            self.recordView.isHidden = false
            self.recordTimerLabel.isHidden = false
        }
        
        if longGestureRecognizer.state == .ended {
            cameraController.recordVideo { (videoURL, error) in
                self.timer?.invalidate()
                self.timerCount = nil
                self.recordView.isHidden = true
                self.recordTimerLabel.isHidden = true
                guard let videoURL = videoURL else {
                    print(error ?? "error nil")
                    return
                }
                self.displayRecordedVideo(videoURL)
            }
        }
    }
    
}

//Rounting
extension CameraViewController {
    
    fileprivate func displayCapturedImage(_ imageData : Data){
//        let vc = UIStoryboard
    }
    
    fileprivate func displayRecordedVideo(_ videoURL : URL){
        
    }
    
}
