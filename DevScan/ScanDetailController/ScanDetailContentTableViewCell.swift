//
//  ScanDetailContentTableViewCell.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/15.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit

class ScanDetailContentTableViewCell: UITableViewCell {
    
    var metaDataObject : DSMetadataObject? = nil
    
    let contentLabel = UILabel()
    var height : CGFloat = 44
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        contentLabel.contentMode = .center
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openInSafari(_ sender: Any) {
        let url = URL(string: (metaDataObject?.stringValue!)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func configCell(object : DSMetadataObject) {
        metaDataObject = object
        contentLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16, height: 44)
        contentLabel.text = object.stringValue
        contentLabel.sizeToFit()
        contentLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: contentLabel.frame.height / 2.0 + 10)
        height = contentLabel.frame.height + 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if selected {
//            let item = UIMenuItem(title: "Copy", action: #selector(copyText))
//            UIMenuController.shared.menuItems = [item]
//            UIMenuController.shared.setTargetRect(self.frame, in: superview!)
//            UIMenuController.shared.setMenuVisible(true, animated: true)
//        }

        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func copyText() {
        
    }

}
