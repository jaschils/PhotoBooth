//
//  Helper.swift
//  PhotoBooth
//
//  Created by John Schils on 4/26/18.
//  Copyright © 2018 HoppyGuy. All rights reserved.
//

import Foundation
import UIKit


class Helper {
    
    //MARK: - UI Convenience Functions
    // App colors
//    static let appLightTintColor:UIColor = UIColor(red:0.27, green:0.73, blue:0.84, alpha:1)
//    static let appDarkTintColor:UIColor = UIColor(red:0.12, green:0.27, blue:0.41, alpha:1)
//    static let colorGray:UIColor = UIColor(red:(128.0/255.0), green:(127.0/255.0), blue:(131.0/255.0), alpha:1)
    static let colorLightGray:UIColor = UIColor(red:(215/255), green:(217/255), blue:(218/255), alpha:1)
//    static let colorBlue:UIColor = UIColor(red:0.0, green:(92.0/255.0), blue:(130.0/255.0), alpha:1)
//    static let colorTeal:UIColor = UIColor(red:(38.0/255.0), green:(188.0/255.0), blue:(215.0/255.0), alpha:1)
//    static let colorGreen:UIColor = UIColor(red:(70.0/255.0), green:(185.0/255.0), blue:(88.0/255.0), alpha:1)
//    static let textViewBorderColor:UIColor = UIColor(red:(220.0/255.0), green:(220.0/255.0), blue:(220.0/255.0), alpha:1)
    
    // Specific photo booth colors
    static let primary_DarkBlue:UIColor         =   UIColor(red: 0.0, green: 0.0, blue: 81/255, alpha: 1)
    static let accent_LightPink:UIColor         =   UIColor(red: 255/255, green: 235/255, blue: 238/255, alpha: 1)
    static let colorRoseGold:UIColor            =   UIColor(red: 183/255, green: 110/255, blue: 121/255, alpha: 1)
    static let colorLightBlue_test:UIColor      =   UIColor(red: 115/255, green: 142/255, blue: 255/255, alpha: 1)
    
    
    /**
     A helper function that modifies text font for a large countdown label
     */
    func countdownLabel(_ label:UILabel) {
        label.textColor = Helper.primary_DarkBlue
        label.font = UIFont.systemFont(ofSize: 400, weight: UIFont.Weight.bold)
    }
    
    
    //MARK: - Functional Convenience Functions
    /**
     This function returns the URL path to the application's documents directory
    */
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /**
     This function updates the total number of photos taken by the app
    */
    func numPhotosTaken() -> Int {
        let fileManager = FileManager.default
        let documentsURL = Helper().getDocumentsDirectory()
        var numPhotos = 0
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            numPhotos = fileURLs.count
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return numPhotos
    }
    
}
