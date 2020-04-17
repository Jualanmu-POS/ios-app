//
//  TransactionListVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class TransactionListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var repo: TransactionRepo!
    private var transactions: [Transaction] = []
    private var filteredData: [Transaction] = []
    private var isFiltering: Bool = false
    
    var eventId: String = ""
    var screenTitle: String = "Transaksi"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        repo = TransactionRepo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getList()
        setNavBar()
        setSearchBar()
    }
    
    private func getList() {
        startLoading()
        repo.getTransactionList(eventId: eventId, onSuccess: { (results) in
            self.setupView(results)
            self.finishLoading()
        }) { (err) in
            self.tableView.reloadData()
            self.finishLoading()
        }
    }
    
    private func setupView(_ results: [Transaction]) {
        transactions = results.reversed()
        if transactions.count > 0 {
            navigationItem.rightBarButtonItem = .init(title: "Tambah", style: .done, target: self, action: #selector(addTapped))
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TransactionListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "EmptyViewCell", bundle: nil), forCellReuseIdentifier: "EmptyViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari No. Resi"
        searchController.searchBar.keyboardType = .numberPad
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func setNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = screenTitle
    }
    
    @objc func addTapped() {
        moveToProductList()
    }
    
    private func moveToProductList() {
        let vc = ProductListVC()
        vc.eventId = eventId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TransactionListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions.count == 0 {
            return 1
        } else {
            return isFiltering ? filteredData.count : transactions.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactions.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyViewCell", for: indexPath) as! EmptyViewCell
            cell.setupView(title: "Anda tidak memiliki transaksi", subtitle: "Tunggu apalagi?", image: "Onboarding3", buttonTitle: "Tambah Transaksi")
            cell.emptyView.actionTapped(tap: moveToProductList)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionListCell
            let item = isFiltering ? filteredData[indexPath.row] : transactions[indexPath.row]
            let dateComponents = item.timestamp.components(separatedBy: " ")
            cell.invoiceLabel.text = "Resi no. \(item.invoice)"
            cell.dateLabel.text = dateComponents[0]
            cell.timeLabel.text = dateComponents[1]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if transactions.count > 0 {
            let transaction: Transaction = isFiltering ? filteredData[indexPath.row] : transactions[indexPath.row]
            getItemTransactions(transaction: transaction)
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return transactions.count > 0 ? UITableView.automaticDimension : tableView.frame.height
//    }
    
    private func getItemTransactions(transaction: Transaction) {
        startLoading()
        repo.getCashier(withId: transaction.userId, onSuccess: { (name) in
            self.repo.getItemTransactions(with: transaction.key, onSuccess: { [weak self] (results) in
                guard let self = self else {return}
                self.showReceipt(name, results, transaction)
            }) { (err) in
                self.finishLoading()
                self.showError(err.localizedDescription)
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
        vc.isEditingMode = false
        vc.receipt = receipt
        vc.key = transaction.key
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TransactionListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        defaultView()
    }
    
    private func defaultView() {
        isFiltering = false
        filteredData.removeAll()
        setupView(transactions)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredData = transactions.filter({return $0.invoice.contains(searchText)})
        isFiltering = true
        tableView.reloadData()
    }
}
