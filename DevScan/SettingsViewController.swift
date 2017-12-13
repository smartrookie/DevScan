//
//  SettingsViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/13.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class SettingsViewController: UITableViewController {
    
    var scanSurportedType : [AVMetadataObject.ObjectType] = CoreDataCenter.shared.metadataObjectTypes
    var scanSurportedTypeFlag : [Bool] = []
    var abountTableViewCell : UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(ScanMetaDataSurportedSwitchCell.self, forCellReuseIdentifier: "surportedCell")
        scanSurportedType.forEach { (objectType) in
            scanSurportedTypeFlag.append(CoreDataCenter.shared.isSurportMetaDataType(type: objectType))
        }
        
        abountTableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        abountTableViewCell?.accessoryType = .disclosureIndicator
        abountTableViewCell?.textLabel?.text = "关于"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return scanSurportedType.count
        }
        else if section == 1 {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ScanMediaType"
        } else if section == 1 {
            return "About"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if indexPath.section == 0 {
            let mediaType = scanSurportedType[indexPath.row]
            let _cell = tableView.dequeueReusableCell(withIdentifier: "surportedCell", for: indexPath) as! ScanMetaDataSurportedSwitchCell
            _cell.textLabel!.text = mediaType.rawValue
            let isSurported = scanSurportedTypeFlag[indexPath.row]
            _cell.surportedSwitch.setOn(isSurported, animated: false)
            
            weak var weakSelf = self
            let row = indexPath.row
            _cell.switchChangeBlock = {(isOn) in
                weakSelf?.scanSurportedTypeFlag[row] = isOn
                CoreDataCenter.shared.addSurportMetaDataType(type: mediaType, isSurported: isOn)
            }
            cell = _cell
        }
        else if indexPath.section == 1 {
            cell = abountTableViewCell!
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1 && row == 0 {
            let about = AboutViewController(style: .grouped)
            navigationController?.pushViewController(about, animated: true)
        }
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class ScanMetaDataSurportedSwitchCell: UITableViewCell {
    
    let surportedSwitch = UISwitch()
    var switchChangeBlock : ((Bool)->())? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = surportedSwitch
        surportedSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
     @objc func switchValueChanged() {
        switchChangeBlock?(surportedSwitch.isOn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}





