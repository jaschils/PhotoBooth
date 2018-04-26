//
//  PhotoCollectionViewCell.swift
//  PhotoBooth
//
//  Created by John Schils on 4/26/18.
//  Copyright © 2018 HoppyGuy. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var capturedImage: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //TODO: SET CAPTURED IMAGE AS THE IMAGES COMING FROM THE APP'S DOCUMENTS FOLDER
        
        capturedImage.layer.masksToBounds = true
        capturedImage.layer.cornerRadius = 7.5
        
    }
}
