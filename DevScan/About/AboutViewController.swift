//
//  AboutViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/12.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
    
    let versionCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于"
        
        versionCell.textLabel?.text = "版本"
        let infoDict = Bundle.main.infoDictionary
        versionCell.detailTextLabel?.text = infoDict!["CFBundleShortVersionString"] as! String + "(" + (infoDict!["CFBundleVersion"] as! String) + ")"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 100
        }
        
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect.zero)
                let icon = UIImageView(image: UIImage(named: "AppIcon"))
                icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                icon.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
                icon.backgroundColor = UIColor.black
                icon.layer.cornerRadius = 10
            view.addSubview(icon)
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect.zero)
                let label = UILabel(frame: CGRect.zero)
                label.text = "我们不收集或共享个人数据"
                label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                label.textColor = UIColor.lightGray
                label.sizeToFit()
                label.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        //let row     = indexPath.row
        if section == 0 {
            return versionCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
