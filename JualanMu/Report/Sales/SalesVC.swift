//
//  SalesVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class SalesVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var productsReports: [ProductReport] = []
    private var salesHeader: SalesHeader!
    private var repo: SalesRepo!
    private let titles: [String] = [
        "Penjualan Terbesar", "Penjualan Terkecil"
    ]
    private let infoProductText = [
        "Produk yang paling laku akan muncul disini",
        "Produk yang jarang dibeli oleh pelanggan\nakan muncul disini"
    ]
    
    private var defaultCellText: [String] = [Date().formatDate(format: .dayNormal), "Total Transaksi Penjualan", "Hari Terbaik", "Jam Terbaik"]
    private var dayCellText: [String] = [Date().formatDate(format: .dayNormal), "Total Transaksi Penjualan", "Jam Terbaik"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewSetup()
        repo = SalesRepo(reportRepo: ReportRepo(transactionRepo: TransactionRepo(), inventoryRepo: InventoryRepo()))
        salesHeader = repo.headerCell(title: "Nama Event", amount: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportList(with: [Date().formatDate()])
        setNavbar()
        segmentedControl.selectedSegmentIndex = 1
        hideTableView(shouldHide: segmentedControl.selectedSegmentIndex == 0)
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        let laporanNib = UINib(nibName: "LaporanCell", bundle: nil)
        let chartNib = UINib(nibName: "ChartCell", bundle: nil)
        tableView.register(laporanNib, forCellReuseIdentifier: "LaporanCell")
        tableView.register(chartNib, forCellReuseIdentifier: "ChartCell")
    }
    
    func setNavbar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Penjualan"
    }
    
    @IBAction func segmentedCtrlSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            salesHeader.title = "Nama Event"
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
        repo.getTransactions(date: date, onSuccess: { (results) in
            self.salesHeader.amount = results.count
            print(results)
        }) { (err) in
            print(err)
        }
        repo.getPerformances(date: date, onSuccess: {
            self.productsReports = $0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (err) in
            print(err)
        }
    }
}

extension SalesVC: LaporanCellDelegate {
    func showAllItem(index: Int) {
        let vc = SoldItemListVC()
        vc.productReports = productsReports
        vc.isAscending = index == 0
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SalesVC:  UITableViewDataSource, UITableViewDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return segmentedControl.selectedSegmentIndex == 1 ? dayCellText.count : defaultCellText.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Sorotan" : nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 50)
        myLabel.font = UIFont.systemFont(ofSize: 34)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = salesHeader.title
            return cell
        case (1,0...1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaporanCell") as! LaporanCell
            cell.delegate = self
            cell.index = indexPath.row
            cell.titleLabel.text = titles[indexPath.row]
            cell.productReports = indexPath.row == 0 ? productsReports : productsReports.reversed()
            
            if productsReports.count <= 0 {
                cell.emptyLabel.isHidden = false
                cell.collectionView.isHidden = true
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = infoProductText[indexPath.row]
            } else {
                cell.emptyLabel.isHidden = true
                cell.collectionView.isHidden = false
                cell.collectionViewSetup()
            }
            return cell
            
//        case (1,2):
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell") as! ChartCell
//            cell.setupView()
//            cell.customizeChart()
//            return cell
        default:
            let cellText: [String] = segmentedControl.selectedSegmentIndex == 1 ? dayCellText : defaultCellText
            var cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell")
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleCell")
            cell?.textLabel?.text = cellText[indexPath.row]
            cell?.detailTextLabel?.text = indexPath.row - 1 == 0 ? "\(salesHeader.amount) Transaksi" : "Belum Ada Data"
            cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            return cell!
        }
    }
}

extension SalesVC {
    
    private func showDatePickerAlert() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "Pilih tanggal", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
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
            salesHeader.title = date.formatDate(format: .dayDetail)
        case 2:
            guard let days = date.addingDate(add: 7),
                let startDate = days.last, let endDate = days.first else {return}
            salesHeader.title = "\(startDate.getAppropriateDateFormat()) - \(endDate.getAppropriateDateFormat())"
        case 3:
            salesHeader.title = date.formatDate(format: .monthYearOnly)
        default:
            return
        }
        
        setupReportView(date: date)
        tableView.reloadData()
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
