//
//  PhotoPreviewViewController.swift
//  PhotoBooth
//
//  Created by John Schils on 5/12/18.
//  Copyright © 2018 HoppyGuy. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var bottomMessage: UILabel!
    
    weak var returnTimer: Timer?
    var count = 3
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if returnTimer == nil {
            returnTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(returnToHome), userInfo: nil, repeats: true)
        }
        
//        let border: UIImage = UIImage(named: "iPad10xFlowers-1")!
//        borderImage.image = border
        
        var documentsURL = Helper().getDocumentsDirectory()
        let selectedImageNum = UserDefaults.standard.integer(forKey: "selectedImageNum")
        documentsURL = documentsURL.appendingPathComponent("PhotoBooth_\(selectedImageNum).png")
        let image = UIImage(contentsOfFile: documentsURL.path)!
        let newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .down)
        previewImage.image = newImage
        
        previewImage.layer.borderWidth = 20
        previewImage.layer.borderColor = Helper.primary_DarkBlue.withAlphaComponent(0.05).cgColor
        
        topMessage.layer.masksToBounds = true
        topMessage.layer.cornerRadius = 7.5
        topMessage.layer.shadowRadius = 3.0
        topMessage.layer.shadowColor = Helper.colorRoseGold.cgColor
        topMessage.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        topMessage.layer.shadowOpacity = 1.0
        
        bottomMessage.layer.masksToBounds = true
        bottomMessage.layer.cornerRadius = 7.5
        bottomMessage.layer.shadowRadius = 3.0
        bottomMessage.layer.shadowColor = Helper.colorRoseGold.cgColor
        bottomMessage.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        bottomMessage.layer.shadowOpacity = 1.0
    }
    
    @objc fileprivate func returnToHome() {
        if(count > 0) {
            count -= 1
        } else if count == 0 {
            if returnTimer != nil {
                returnTimer?.invalidate()
                returnTimer = nil
            }
            performSegue(withIdentifier: "segToHome", sender: self)
        }
    }
}
