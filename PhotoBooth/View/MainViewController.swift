//
//  MainViewController.swift
//  PhotoBooth
//
//  Created by John Schils on 4/25/18.
//  Copyright © 2018 HoppyGuy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    let fileManager = FileManager.default
    weak var appTimer:  Timer?
    weak var countdown: Timer?
    var count = 5
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var arrowOne: SpringImageView!
    @IBOutlet weak var arrowTwo: SpringImageView!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
//        askPermission()
        
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .front)!
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer.frame = previewView.bounds
                    previewLayer.connection?.videoOrientation = .landscapeRight
                    previewView.layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
        
        animateArrows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appTimer = Timer.scheduledTimer(timeInterval: 4.1, target: self, selector: #selector(animateArrows), userInfo: nil, repeats: true)
        photoCollectionView.backgroundColor = Helper.primary_DarkBlue.withAlphaComponent(0.05)        //colorTeal.withAlphaComponent(0.85)
        photoCollectionView.reloadData()
        previewView.bringSubview(toFront: actionView)
    }

    @IBAction func didPressPhotoButton(_ sender: UIButton) {
        countdownView.isHidden = false
        Helper().countdownLabel(countdownLabel)
        if countdown == nil {
            countdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(photoCountdown), userInfo: nil, repeats: true)
        }
    }
    
    // callBack from take picture
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer, // TODO: FIGURE OUT USE OF [AVCapturePhoto fileDataRepresentation]
//            let imageData = previewBuffer.fileDataRepresentation()
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer)
        {
            print(UIImage(data: imageData)?.size as Any)
            let numPhotosTaken = Helper().numPhotosTaken()
            let filename = Helper().getDocumentsDirectory().appendingPathComponent("FriendsGiving_\(numPhotosTaken).png")
            print("Saving file - filename.path:  \(filename.path)")
            fileManager.createFile(atPath: filename.path, contents: imageData, attributes: nil)
            photoCollectionView.reloadData()
        } else {
            print("some error here")
        }
    }
    
    // This method you can use somewhere you need to know camera permission   state
    func askPermission() {
        print("Verifying permission status for application camera and photo use")
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraPermissionStatus {
        case .authorized:
            print("Already Authorized")
        case .denied:
            print("denied")
            
            let alert = UIAlertController(title: "Sorry :(" , message: "But  could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                
                if granted == true {
                    // User granted
                    print("User granted")
                    DispatchQueue.main.async(){
                        //Do smth that you need in main thread
                    }
                }
                else {
                    // User Rejected
                    print("User Rejected")
                    
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
    
    @objc fileprivate func animateArrows() {
        arrowOne.animation = "morph"
        arrowOne.duration = 2
        arrowOne.repeatCount = 2
        arrowOne.animate()
        
        arrowTwo.animation = "morph"
        arrowTwo.duration = 2
        arrowTwo.repeatCount = 2
        arrowTwo.animate()
    }
    
    @objc fileprivate func photoCountdown() {
        if(count > 0) {
            countdownView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
//            countdownView.alpha = 0.85
            count -= 1
            let countString = "\(count)"
            countdownLabel.text = countString
            actionView.isHidden = true
            arrowOne.isHidden = true
            arrowTwo.isHidden = true
            photoCollectionView.isHidden = true
            photoBtn.isHidden = true
            previewView.bringSubview(toFront: countdownView)
        } else if count == 0 {
            if countdown != nil {
                countdown?.invalidate()
                countdown = nil
            }
            
            previewView.sendSubview(toBack: countdownView)
            count = 5
            let settings = AVCapturePhotoSettings()
            let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
            let previewFormat = [
                kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                kCVPixelBufferWidthKey as String: 150,
                kCVPixelBufferHeightKey as String: 150
            ]
            settings.isAutoStillImageStabilizationEnabled = true
            settings.flashMode = .off
            settings.previewPhotoFormat = previewFormat
            
            cameraOutput.capturePhoto(with: settings, delegate: self)
            
            actionView.isHidden = false
            arrowOne.isHidden = false
            arrowTwo.isHidden = false
            photoCollectionView.isHidden = false
            photoBtn.isHidden = false
            countdownView.isHidden = true
            
            //TODO: SEGUE TO PHOTO PREVIEW
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                let numPhotosTaken = Helper().numPhotosTaken()
//                UserDefaults.standard.set(numPhotosTaken, forKey: "selectedImageNum")
//                self.performSegue(withIdentifier: "segToPreview", sender: self)
//            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func willEnterBackground() {
        if appTimer != nil {
            appTimer?.invalidate()
            appTimer = nil
        }
        
        if countdown != nil {
            countdown?.invalidate()
            countdown = nil
        }
    }
    
    //MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Helper().numPhotosTaken()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = Helper.colorLightGray.withAlphaComponent(0.35)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 7.5
        
        let filename = Helper().getDocumentsDirectory().appendingPathComponent("PhotoBooth_\(indexPath.row).png").path
        if fileManager.fileExists(atPath: filename){
            let data = fileManager.contents(atPath: filename)
            let dataProvider = CGDataProvider(data: data! as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            cell.capturedImage.image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.downMirrored)
        }else{
            print("Panic! No Image!")
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageNum = indexPath.row
        UserDefaults.standard.set(selectedImageNum, forKey: "selectedImageNum")
        performSegue(withIdentifier: "segToPreview", sender: self)
    }
}

