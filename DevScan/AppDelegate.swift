//
//  AppDelegate.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        let scanHistoryController = ScanHistoryViewController()
        scanHistoryController.managedObjectContext = CoreDataCenter.shared.persistentContainer.viewContext
        let navigationController  = UINavigationController(rootViewController: scanHistoryController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataCenter.shared.saveContext()
    }

   
}

