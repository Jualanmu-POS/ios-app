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
    
    private var items: [EventItem] = []
    private var repo: EventRepo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewSetup()
        setUIComponent()
        repo = EventRepo()
        items = repo.createItems()
    }

    func tableViewSetup() {
        let nib = UINib(nibName: "EventFormCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventFormCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUIComponent() {
        navigationItem.title = "Event Form"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped() {
        guard let uid: String = Preference.getString(forKey: .kUserUid) else {return}
        let event: Event = Event(
            name: items[0].content,
            startDate: items[1].content,
            endDate: items[2].content,
            location: items[3].content,
            timestamp: Date().formatDate(),
            shopId: uid, key: "")
        repo.submitEvent(event: event, onSuccess: { (_) in
            self.navigationController?.popViewController(animated: true)
        }) { (err) in
            print(err)
        }
    }
}

extension EventFormVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFormCell") as! EventFormCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.textField.placeholder = items[indexPath.row].content
        cell.setupTapGesture(indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1...2:
            showDatePickerAlert(indexPath.row)
        default:
            return
        }
    }
}


extension EventFormVC: FieldCellDelegate {
    func onFieldChanging(text: String, indexPath: IndexPath) {
        //
    }
    
    func onFieldBeginEditing(text: String, indexPath: IndexPath) {
        //
    }
    
    
    func onFieldEndEditing(text: String, indexPath: IndexPath) {
        items[indexPath.row].content = text
    }
    
    private func showDatePickerAlert(_ row: Int) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "Select a date", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width - 20, height: 140)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.items[row].content = datePicker.date.formatDate()
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
