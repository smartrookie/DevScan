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
        }
        
        return UIViewController()
    }
    
}
