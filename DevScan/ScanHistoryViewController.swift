//
//  ScanHistoryViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData

class ScanHistoryViewController: UITableViewController , NSFetchedResultsControllerDelegate{
    
    var managedObjectContext : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DevScan"
        
        self.clearsSelectionOnViewWillAppear = true
        
        let leftBarButton = UIBarButtonItem(image:UIImage(named:"扫一扫"), style:.plain, target: self, action: #selector(scanCamera))
        navigationItem.leftBarButtonItem = leftBarButton
        tableView.register(ScanHistoryTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "设置"), style: .plain, target: self, action: #selector(settingPage))
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func scanCamera() {
        let scanViewController = ScanViewController()
        scanViewController.managedObjectContext = self.managedObjectContext
        let navigationController = UINavigationController(rootViewController: scanViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func settingPage() {
        let settingsViewController = SettingsViewController(style: .grouped)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withObject: event)

        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withObject object: DSMetadataObject) {
        cell.textLabel!.text = object.type!.description
        cell.detailTextLabel?.text = object.stringValue?.description
        
        var iconName : String = ""
        switch object.type!.description {
        case "org.iso.QRCode":
            iconName = "二维码扫描"
        case "face":
            iconName = "人脸扫描"
        case "org.iso.Code128","org.gs1.EAN-8","org.gs1.EAN-13":
            iconName = "条形码扫描"
        default:
            iconName = ""
        }
        let iconImage = UIImage(named:iconName)
        
        cell.imageView?.image = iconImage
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                
            }
        } else if editingStyle == .insert {
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metaData = fetchedResultsController.object(at: indexPath)
        let detailController = ScanDetailFactory.factory(metaObject: metaData)
        navigationController?.pushViewController(detailController, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    var fetchedResultsController: NSFetchedResultsController<DSMetadataObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<DSMetadataObject> = DSMetadataObject.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<DSMetadataObject>? = nil
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withObject: anObject as! DSMetadataObject)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withObject: anObject as! DSMetadataObject)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     tableView.reloadData()
     }
     */

}






