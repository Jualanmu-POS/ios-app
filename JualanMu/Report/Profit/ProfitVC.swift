//
//  ProfitVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 19/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class ProfitVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    let datePicker = UIDatePicker()
    
    private var productReports: [ProductReport] = []
    private var repo: ProfitRepo!
    private var header: ProfitHeader!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewSetup()
        SegmentedControlSetup()
        repo = ProfitRepo(reportRepo: ReportRepo(transactionRepo: TransactionRepo(), inventoryRepo: InventoryRepo()))
        header = repo.headerCell(title: "Nama Event", amount: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
        getReportList(with: [Date().formatDate()])
        segmentedControl.selectedSegmentIndex = 1
        hideTableView(shouldHide: segmentedControl.selectedSegmentIndex == 0)
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func SegmentedControlSetup(){
        backgroundView.backgroundColor = tableView.backgroundColor
    }

    func setNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Laba"
    }
    
    @IBAction func segmentedCtrlSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            header.title = "Nama Event"
            hideTableView(shouldHide: true)
        case 1:
            getReportList(with: [Date().formatDate()])
            hideTableView(shouldHide: false)
        case 2:
            guard let results = Date().addingDate(add: 7) else {return}
            getReportList(with: results)
            hideTableView(shouldHide: false)
        case 3:
            guard let results = Date().firstDayOfTheMonth().getAllDays() else {return}
            getReportList(with: results)
            hideTableView(shouldHide: false)
        default:
            return
        }
        refreshView(date: Date())
        tableView.reloadData()
    }
    
    private func hideTableView(shouldHide: Bool) {
        tableView.isHidden = shouldHide
        if shouldHide {
            comingsoonAlert(msg: "Event")
        }
    }
    
    private func getReportList(with date: [String]) {
        var amount: Double = 0.0
        repo.getPerformances(date: date, onSuccess: {
            self.productReports = $0
            $0.forEach({amount += $0.total})
            self.header.amount = amount
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (err) in
            print(err)
        }
    }
}

//extension Formatter {
//    static let date = DateFormatter()
//}

extension ProfitVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row, segmentedControl.selectedSegmentIndex) {
        case (0,0,1...2):
            showDatePickerAlert()
        case (0,0,3):
            showMonthPickerAlert()
        default:
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Sumber Laba" : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNonzeroMagnitude : 22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return productReports.count
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cellText = [segmentedControl.selectedSegmentIndex == 0 ? "Nama Event" : header.title, "Total Laba"]
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell?.textLabel?.text = cellText[indexPath.row]
            cell?.detailTextLabel?.text = indexPath.row == 1 ? header.amount.currencyFormat() : nil
            cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            return cell!
            
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            let productReport = productReports[indexPath.row]
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell?.textLabel?.text = "SKU:\(productReport.sku)"
            cell?.detailTextLabel?.text = productReport.total.currencyFormat()
            cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.07843137255, green: 0.5490196078, blue: 0.05098039216, alpha: 1)
            
            return cell!
            
        default:
            return UITableViewCell()
        }
    }
}

extension ProfitVC {
    private func showDatePickerAlert() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "Select a date", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width - 20, height: 140)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.refreshView(date: datePicker.date)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showMonthPickerAlert() {
        let monthPicker = MonthYearPickerView()
        var date: Date = Date()
        
        monthPicker.onDateSelected = { (month: Int, year: Int) in
            let string = "\(monthPicker.months[month - 1]) \(year)"
            print(string)
            date = string.asDate
        }
        
        let alert = UIAlertController(title: "Pilih bulan", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(monthPicker)
        monthPicker.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width - 20, height: 140)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.refreshView(date: date)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func refreshView(date: Date) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            header.title = date.formatDate(format: .dayDetail)
        case 2:
            guard let days = date.addingDate(add: 7),
                let startDate = days.last, let endDate = days.first else {return}
            header.title = "\(startDate.getAppropriateDateFormat()) - \(endDate.getAppropriateDateFormat())"
        case 3:
            header.title = date.formatDate(format: .monthYearOnly)
        default:
            return
        }
    }
    
    private func setupReportView(date: Date) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            getReportList(with: [date.formatDate()])
        case 2:
            guard let results = date.addingDate(add: 7) else {return}
            getReportList(with: results)
        case 3:
            guard let results = date.firstDayOfTheMonth().getAllDays() else {return}
            getReportList(with: results)
        default:
            return
        }
    }
}
