//
//  CoreDataCenter.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData

class CoreDataCenter {
    
    private static var instance :CoreDataCenter = CoreDataCenter()
    class var shared: CoreDataCenter {
        return instance
    }
    
    private init() {
        
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
    }
}
