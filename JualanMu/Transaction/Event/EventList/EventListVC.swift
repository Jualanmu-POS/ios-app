//
//  EventListVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 06/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class EventListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var repo: EventRepo!
    private var events: [Event] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavbar()
        getEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        repo = EventRepo()
    }
    
    private func getEvents() {
        startLoading()
        repo.getEvents(onSuccess: { (results) in
            self.events = results
            DispatchQueue.main.async {
                self.finishLoading()
                self.tableView.reloadData()
            }
        }) { (err) in
            self.finishLoading()
            print(err)
        }
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setNavbar() {
        self.navigationItem.title = "Event"
        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 0.8206087947, blue: 0.2826492786, alpha: 1)
        navigationItem.rightBarButtonItem = .init(title: "Tambah", style: .done, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        navigationController?.pushViewController(EventFormVC(), animated: true)
    }
}

extension EventListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TransactionListVC()
        vc.eventId = events[indexPath.row].key
        vc.screenTitle = events[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count == 0 ? 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return events.count == 0 ? tableView.frame.height : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if events.count == 0 {
            return emptyCell()
        }
        let cell = UITableViewCell()
        let event = events[indexPath.row]
        cell.textLabel?.text = "\(event.name)"
        return cell
    }
    
    func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Belum ada event"
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = tableView.backgroundColor
        cell.textLabel?.textColor = .gray
        tableView.separatorStyle = .none
        return cell
    }
}
