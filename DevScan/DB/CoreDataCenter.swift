//
//  CoreDataCenter.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

let kCoreDataCenter_SurportedMetaDataObjectType_Notification = "kCoreDataCenter_SurportedMetaDataObjectType_Notification"

class CoreDataCenter {
    
    private static var instance :CoreDataCenter = CoreDataCenter()
    class var shared: CoreDataCenter {
        return instance
    }
    
    private init() {
        initialScanRange()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DevScan")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    static let kScanRangeKey = "kScanRangeKey"
    
    var _metadataObjectTypes: [AVMetadataObject.ObjectType]? = nil
    lazy var metadataObjectTypes:[AVMetadataObject.ObjectType] = {
        _metadataObjectTypes = UserDefaults.standard.object(forKey: CoreDataCenter.kScanRangeKey) as? [AVMetadataObject.ObjectType]
        return _metadataObjectTypes!
    }()
    
    func isSurportMetaDataType(type: AVMetadataObject.ObjectType) -> Bool {
        let isSurported = UserDefaults.standard.value(forKey: type.rawValue) as? Bool
        return isSurported ?? false
    }
    
    func addSurportMetaDataType(type:AVMetadataObject.ObjectType, isSurported: Bool) {
        UserDefaults.standard.set(isSurported, forKey: type.rawValue)
        let info = [
            "type":type,
            "surport":isSurported
            ] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCoreDataCenter_SurportedMetaDataObjectType_Notification), object: nil, userInfo: info)
    }
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    func initialScanRange() {
        
        let userDefault = UserDefaults.standard
        if let _ = userDefault.object(forKey: CoreDataCenter.kScanRangeKey) {
            
        } else {
            let scanArr : [AVMetadataObject.ObjectType] = [.qr,
                                                           .ean8,
                                                           .ean13,
                                                           .upce,
                                                           .code39,
                                                           .code93,
                                                           .code128,
                                                           .code39Mod43,
                                                           .aztec,
                                                           //.face,
                                                           .dataMatrix,
                                                           .interleaved2of5,
                                                           .itf14,
                                                           .pdf417,]
            userDefault.setValue(scanArr, forKey: CoreDataCenter.kScanRangeKey)
            scanArr.forEach({ (type) in
                userDefault.setValue(true, forKey: type.rawValue)
            })
            
        }
    }
    
    
}
