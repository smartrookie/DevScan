//
//  ScanHistoryTableViewCell.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/13.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit

class ScanHistoryTableViewCell: UITableViewCell {
    
    var metaDataObject : DSMetadataObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    @objc func openInSafari(_ sender: Any) {
        let url = URL(string: (metaDataObject?.stringValue!)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
