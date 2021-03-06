//
//  ScanMediaDetailViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/14.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData

class ScanDetailFactory {
    
    class func factory(metaObject: DSMetadataObject) -> UIViewController {
        
        if metaObject.type == "org.iso.QRCode" {
            let detailController = ScanQRCodeDetailViewController(style: .grouped)
            detailController.metaDataObject = metaObject
            return detailController
        } else if  metaObject.type == "org.iso.Code128"
                || metaObject.type == "org.gs1.EAN-8"
                || metaObject.type == "org.gs1.EAN-13"
                || metaObject.type == "org.iso.Code39"
                || metaObject.type == "org.iso.Code93"
                || metaObject.type == "org.iso.Code128"
                || metaObject.type == "org.iso.Code39Mod43"
                || metaObject.type == "org.ansi.Interleaved2of5" {
            let detailController = ScanBarCodeDetailViewController(style: .grouped)
            detailController.metaDataObject = metaObject
            return detailController
        } else if metaObject.type == "face" {
            let detailController = ScanFaceDetailViewController(style: .grouped)
            detailController.metaDataObject = metaObject
            return detailController
        }
        
        return UIViewController()
    }
    
}
