//
//  ScanViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ScanViewController: UIViewController {
    
    let scanSession = AVCaptureSession()
    var managedObjectContext: NSManagedObjectContext? = nil
    let metadataOutput : AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描"
        view.backgroundColor = UIColor.black

        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image:UIImage(named:"相册"), style:.plain, target:self, action:#selector(openAlbumAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
        let authStatus =  AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
            case .authorized, .notDetermined,.restricted:
                initialCamera()
            break
            case .denied :
                authorizedAlert()
            break
        }
    }
    
    func authorizedAlert() {
        let alertController = UIAlertController(title: nil, message: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头", preferredStyle: .alert)
        let commit = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(commit)
        present(alertController, animated: true, completion: nil)
    }
    
    func initialCamera() {
        let device = AVCaptureDevice.default(for: .video)
        
        var input : AVCaptureDeviceInput? = nil
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {}
        
        if scanSession.canAddInput(input!) {
            scanSession.addInput(input!)
        }
        
        
        let output = metadataOutput
        
        scanSession.canSetSessionPreset(.high)
        
        if scanSession.canAddOutput(output) {
            scanSession.addOutput(output)
        }
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        var types : [AVMetadataObject.ObjectType] = []
        CoreDataCenter.shared.metadataObjectTypes.forEach { (object) in
            if CoreDataCenter.shared.isSurportMetaDataType(type: object) {
                types.append(object)
            }
        }
        output.metadataObjectTypes = types;
        
        let scanPreviewLayer = AVCaptureVideoPreviewLayer(session: scanSession)
        scanPreviewLayer.videoGravity = .resizeAspectFill
        scanPreviewLayer.frame = view.bounds
        
        view.layer.addSublayer(scanPreviewLayer)
        
        if (device?.isFocusModeSupported(.autoFocus))! {
            do {
                try input?.device.lockForConfiguration()
                input?.device.focusMode = .autoFocus
                input?.device.unlockForConfiguration()
            } catch {}
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil) { (notification) in
            output.rectOfInterest = scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.view.bounds)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if scanSession.isRunning {
            scanSession.stopRunning()
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func insertNewObject(_ result: AVMetadataObject) {
        let context = self.managedObjectContext!
        let object = DSMetadataObject(context: context)
        
        object.timestamp = Date()
        object.type = result.type.rawValue
//        object.bounds = result.bounds?
//        object.duration = result.duration?
        if result is AVMetadataMachineReadableCodeObject {
            object.stringValue = (result as! AVMetadataMachineReadableCodeObject).stringValue
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate ,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        if (pixelBuffer != nil) {
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer!, options: attachments as? [String : Any])
            let image = UIImage(ciImage: ciImage)
            print("image = \(image)")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanSession.stopRunning()
        
        metadataObjects.forEach { (object) in
            if object.type == AVMetadataObject.ObjectType.face {
                return
            } else {
                insertNewObject(object)
            }
        }
        
        dismiss(animated: true, completion: {
            CoreDataCenter.shared.saveContext()
        })
    }
}

extension ScanViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
   @objc func openAlbumAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let inputImage = CIImage(image: image)
        
        let ciContext = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        let detectorType = CIDetectorTypeQRCode
    
        let detector = CIDetector(ofType: detectorType, context: ciContext, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
        if let features : [CIQRCodeFeature] = detector!.features(in: inputImage!) as? [CIQRCodeFeature]{
            //print(features)
            features.forEach({ (feature) in
                insertNewObject(feature: feature)
            })
            
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        /*
        detectorType = CIDetectorTypeFace
        detector = CIDetector(ofType: detectorType, context: ciContext, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
        var features : [CIFaceFeature]?
        if let orientation:[kCGImagePropertyOrientation] = inputImage!.properties()?[kCGImagePropertyOrientation] {
            feature = detector?.features(in: inputImage!, options: [CIDetectorImageOrientation:orientation])
        } else {
            feature = detector?.features(in: inputImage!)
        }
        features?.forEach({ (feature) in
            insertNewObject(feature: feature)
        })
         */
    }
    
    func insertNewObject(feature: CIFeature) {
        
        if feature is CIQRCodeFeature {
            let qrFeature = feature as! CIQRCodeFeature
            let context = self.managedObjectContext!
            let object = DSMetadataObject(context: context)
            object.type = "org.iso.QRCode"
            object.stringValue = qrFeature.messageString
            object.timestamp = Date()
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
