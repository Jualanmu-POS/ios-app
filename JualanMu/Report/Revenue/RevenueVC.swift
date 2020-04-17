//
//  RevenueVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 20/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class RevenueVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    private var revenueHeader: RevenueHeader!
    private var repo: RevenueRepo!
    private var revenues: [Revenue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SegmentedControlSetup()
        tableViewSetup()
        repo = RevenueRepo(inventoryRepo: InventoryRepo(), transactionRepo: TransactionRepo())
        revenueHeader = repo.headerCell(title: "Nama Event", amount: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
        setSearchBar()
        getReportList(with: [Date().formatDate()])
        segmentedControl.selectedSegmentIndex = 1
        hideTableView(shouldHide: segmentedControl.selectedSegmentIndex == 0)
    }
    
    private func hideTableView(shouldHide: Bool) {
        tableView.isHidden = shouldHide
        if shouldHide {
            comingsoonAlert(msg: "Event")
        }
    }
    
    private func getReportList(with date: [String]) {
        startLoading()
        revenues.removeAll()
        date.forEach { (timeStamp) in
            self.repo.getTransactions(date: timeStamp, onGetRevenue: { (revenue) in
                self.finishLoading()
                self.revenues.append(revenue)
                if revenue.transactions.count > 0 {self.getRevenue(revenue: revenue, date: timeStamp)}
                else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.revenueHeader.amount = 0
                    }
                }
            }) { (err) in
                self.finishLoading()
                print(err)
            }
        }
    }
    
    private func getRevenue(revenue: Revenue, date: String) {
        var amount: Double = 0.0
        revenue.transactions.forEach({amount += $0.total; revenueHeader.amount = amount})
        repo.getRevenue(total: amount, date: date, onSuccess: { (amount) in
            self.revenueHeader.amount = amount
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (err) in
            print(err)
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "RevenueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RevenueCell")
    }
    
    func SegmentedControlSetup() {
        backgroundView.backgroundColor = tableView.backgroundColor
    }

    func setNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Pemasukan"
    }
    
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Item"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func segmentedCtrlSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            revenueHeader.title = "Nama Event"
            hideTableView(shouldHide: true)
        case 1...3:
            refreshView(date: Date())
            hideTableView(shouldHide: false)
        default:
            return
        }
        tableView.reloadData()
    }

}

extension RevenueVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return revenues.count + 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Transaksi"
        default:
            return revenues[section-2].date.getAppropriateDateFormat()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 34)
            myLabel.font = UIFont.systemFont(ofSize: 34)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
        
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        case 1:
            return 34
        default:
            return 22
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 0
        default:
            return revenues[section-2].transactions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = indexPath.row == 0 ? revenueHeader.title : "Total Pemasukan"
            cell.detailTextLabel?.text = indexPath.row == 1 ? revenueHeader.amount.currencyFormat() : nil
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            return cell
    
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RevenueCell") as! RevenueCell
            let transaction = revenues[indexPath.section-2].transactions[indexPath.row]
            cell.transactionID.text = transaction.invoice
            cell.timeLabel.text = String(transaction.timestamp.split(separator: " ").last ?? "")
            cell.totalRevenue.text = transaction.total.currencyFormat()
            return cell
        }
    }
    
    
}

extension RevenueVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
}

extension RevenueVC {
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
            revenueHeader.title = date.formatDate(format: .dayDetail)
        case 2:
            guard let days = date.addingDate(add: 7),
                let startDate = days.last, let endDate = days.first else {return}
            revenueHeader.title = "\(startDate.getAppropriateDateFormat()) - \(endDate.getAppropriateDateFormat())"
        case 3:
            revenueHeader.title = date.formatDate(format: .monthYearOnly)
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
            getReportList(with: results.reversed())
        case 3:
            guard let results = date.firstDayOfTheMonth().getAllDays() else {return}
            getReportList(with: results.reversed())
        default:
            return
        }
    }
}

extension RevenueVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section >= 2 {
            let transaction = revenues[indexPath.section-2].transactions[indexPath.row]
            getItemTransactions(transaction: transaction)
        } else {
            switch (indexPath.section, indexPath.row, segmentedControl.selectedSegmentIndex) {
            case (0,0,1...2):
                showDatePickerAlert()
            case (0,0,3):
                showMonthPickerAlert()
            default:
                return
            }
        }
    }
    
    private func getItemTransactions(transaction: Transaction) {
        startLoading()
        repo.getCashier(withId: transaction.userId, onSuccess: { (name) in
            self.repo.getItemTransactions(with: transaction.key, onSuccess: { [weak self] (results) in
                guard let self = self else {return}
                self.showReceipt(name, results, transaction)
            }) { (err) in
                print(err)
            }
        }) { (err) in
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    private func showReceipt(_ name: String, _ results: [ItemTransaction], _ transaction: Transaction) {
        finishLoading()
        var products: [Product] = []
        results.forEach { (item) in
            if item.transactionId == transaction.key {
                let product: Product = Product(id: item.id, name: item.itemName, image: "", category: "", code: "", cost: 0.0, margin: 0.0, price: item.price, currentStock: 0, minimumStock: 0, shopId: "", userId: "", timeStamp: item.timestamp, quantity: item.quantity, productId: "", isSelected: true)
                products.append(product)
            }
        }
        let receipt: Receipt = Receipt(products: products, cashierName: name, total: transaction.total.currencyFormat(), change: transaction.change.currencyFormat(), cash: transaction.cash.currencyFormat(), invoiceNumber: transaction.invoice, transactionDate: transaction.timestamp)
        let vc: ReceiptVC = ReceiptVC()
        vc.isReadingMode = true
        vc.isEditingMode = false
        vc.receipt = receipt
        vc.key = transaction.key
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}
