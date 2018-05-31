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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("fileURLs:\n\(fileURLs)")
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
