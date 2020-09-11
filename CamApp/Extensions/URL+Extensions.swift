//
//  URL+Extensions.swift
//  CamApp
//
//  Created by Mhmd Rizk on 9/11/20.
//  Copyright © 2020 Mhmd Rizk. All rights reserved.
//

import Foundation
import AVKit

extension URL {
    
    func getThumbnailImageFromVideoUrl(completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: self) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
}

