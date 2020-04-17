//
//  TopEventVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class TopStaffVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableTitleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewSetup()
        cellButton.layer.borderWidth = 1
        cellButton.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
        tableTitleView.layer.borderWidth = 1
        tableTitleView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TopStaffCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    func setNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Top Staff"
    }
    
    @IBAction func segmentedCtrlSelected(_ sender: Any) {
        
        let index = segmentedControl.selectedSegmentIndex
//        let currentDate = Date().localizedDescription
        switch index {
        case 0:
            cellButton.setTitle("eventName", for: .normal)
//        case 1:
////            cellButton.setTitle(Date().fullDate, for: .normal)
//        case 2:
////            cellButton.setTitle(Date().fullDate, for: .normal)
//        case 3:
//            cellButton.setTitle(Date().fullDate, for: .normal)
        default:
            break
        }
    }
    
    @IBAction func cellButtonTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1...2:
            showDatePickerAlert()
        case 3:
            break
        default:
            break
        }
    }
    
    func showDatePickerAlert() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "Select a date", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width - 20, height: 140)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            self.cellButton.setTitle(dateString, for: .normal)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension TopStaffVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TopStaffCell
        cell.staffName.text = "Mamang"
        cell.revenueLabel.text = "Rp \(indexPath.row + 1).000.000"
        cell.qtyLabel.text = "\(indexPath.row + 2)00"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
