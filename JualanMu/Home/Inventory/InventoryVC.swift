//
//  InventoryVC.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class InventoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Inventory"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
