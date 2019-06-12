//
//  CameraController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/23/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = paletteSystemBlue
        setupCameraCaptureSession()
        
        view.addSubview(captureButtonAnimation)
        captureButtonAnimation.anchor(topAnchor: nil, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 250)
        
        view.addSubview(captureButton)
        captureButton.anchor(topAnchor: nil, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 250)
        
        
        view.addSubview(dismissButton)
        dismissButton.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 100, height: 100)
    }
    
    let captureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let captureButtonAnimation: LOTAnimationView = {
        let button = LOTAnimationView(name: "capture_green")
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let output = AVCapturePhotoOutput()
    var image = UIImage()
    
    fileprivate func setupCameraCaptureSession(){
        let captureSession = AVCaptureSession()
        
        //let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        //previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // 1. set up inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
                
            }
        }catch let err{
            print("Could not setup Camera input",err)
        }
        
        // 2. set up output
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // 3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    
    @objc func handleCapturePhoto() {
        captureButtonAnimation.play()
        print("HandleCapture")
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        //let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        //let previewImage = UIImage(data: imageData!)
        print("Finish Processing Photo Sample Buffer...")
    }
}
