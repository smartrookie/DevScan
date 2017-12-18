//
//  ScanFaceDetailViewController.swift
//  DevScan
//
//  Created by smartrookie on 2017/12/15.
//  Copyright © 2017年 smartrookie. All rights reserved.
//

import UIKit

class ScanFaceDetailViewController: UITableViewController {

    var metaDataObject : DSMetadataObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
