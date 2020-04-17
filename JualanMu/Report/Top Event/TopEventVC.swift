//
//  TopEventVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class TopEventVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "TopEventCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Top Event"
        backgroundView.backgroundColor = tableView.backgroundColor
    }

}

extension TopEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TopEventCell
        cell.eventNameLabel.text = "Event \(indexPath.row)"
        cell.datesLabel.text = "\(indexPath.row) - \(indexPath.row + 5) Nov 2019"
        cell.totalProfitLabel.text = "Rp \(indexPath.row + 1)0.000.000"
        cell.qtyLabel.text = "\(indexPath.row + 1)00"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
