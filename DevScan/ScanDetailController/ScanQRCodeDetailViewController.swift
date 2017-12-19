//
//  ScanQRCodeDetailViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/14.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit
import EFQRCode

class ScanQRCodeDetailViewController: UITableViewController {
    
    var metaDataObject : DSMetadataObject?
    let contentCell = ScanDetailContentTableViewCell(style: .default, reuseIdentifier: nil)
    let qrImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
    var isUrl : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "二维码"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        qrImageView.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: 100)
        qrImageView.layer.borderWidth = 2.0
        qrImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        qrImageView.image = UIImage(cgImage: EFQRCode.generate(content: (metaDataObject?.stringValue)!)!)
        
        contentCell.configCell(object: metaDataObject!)
        
        let regex = "[a-zA-z]+://[^\\s]*"
        let isUrlPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        isUrl = isUrlPredicate.evaluate(with: metaDataObject?.stringValue!)
        
        if isUrl {
            let menu = UIMenuItem(title: "Safari", action: #selector(openInSafari(_:)))
            let menuController = UIMenuController.shared
            menuController.menuItems = [menu]
            menuController.update()
        }
    }
    
    @objc func openInSafari(_ sender: Any) {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect.zero)
            
            view.addSubview(qrImageView)
            return view
        }
        
        return nil
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            if isUrl {
                return "长按拷贝或在Safari中打开"
            } else {
                return "长按拷贝"
            }
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return contentCell.height
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0 {
            return contentCell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }
        if action == #selector(openInSafari(_:)) {
            return isUrl
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            UIPasteboard.general.string = contentCell.contentLabel.text
        }
    }
    
}

















