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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描二维码"
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image:UIImage(named:"相册"), style:.plain, target:self, action:nil)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let device = AVCaptureDevice.default(for: .video)
        var input : AVCaptureDeviceInput? = nil
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {}
        
        let output = AVCaptureMetadataOutput()
        
        scanSession.canSetSessionPreset(.high)
        
        if scanSession.canAddInput(input!) {
            scanSession.addInput(input!)
        }
        
        if scanSession.canAddOutput(output) {
            scanSession.addOutput(output)
        }
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [
            .qr,
        ];
        
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
    
    func insertNewObject(_ sender: Any) {
        let context = self.managedObjectContext!
        let object = DSMetadataObject(context: context)
        
        object.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanSession.stopRunning()
        if metadataObjects.count > 0 {
            let result = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        
            dismiss(animated: true, completion: {
                self.insertNewObject(result)
            })
        }
    }
}
