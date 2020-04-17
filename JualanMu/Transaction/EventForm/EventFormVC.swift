//
//  EventFormVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 11/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class EventFormVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let formText = ["Event Name", "Dates", "Location"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewSetup()
        setUIComponent()
    }

    func tableViewSetup() {
        let nib = UINib(nibName: "EventFormCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventFormCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUIComponent() {
        navigationItem.title = "Buat Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension EventFormVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFormCell") as! EventFormCell
        cell.titleLabel.text = formText[indexPath.row]
        cell.textField.placeholder = "Not Set"
        return cell
    }
    
    
}
