//
//  ReceiptVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 11/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class ReceiptVC: UIViewController {

    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cashierName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalCash: UILabel!
    @IBOutlet weak var totalChange: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var emailView: UIStackView!
    
    var receipt: Receipt!
    var repo: TransactionRepo!
    var key: String = ""
    var isEditingMode: Bool = true
    var isReadingMode: Bool = false
    var inventoryRepo: InventoryRepo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repo = TransactionRepo()
        inventoryRepo = InventoryRepo()
        tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUIComponent()
        getLastTransaction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func getLastTransaction() {
        if key.elementsEqual("") {
            repo.getLastTransactionId(onSuccess: setupView(key:)) { (err) in
                print(err)
            }
        } else {
            setupView(key: key)
        }
    }
    
    private func setupView(key: String) {
        let cahsierName: String = receipt.cashierName
        let dateComponents = receipt.transactionDate.components(separatedBy: " ")
        dateLabel.text = dateComponents[0]
        timeLabel.text = dateComponents[1]
        invoiceNumber.text = "Resi No. " + receipt.invoiceNumber
        totalChange.text = Double(receipt.total.removeCurrency() - receipt.cash.removeCurrency()).currencyFormat()
        totalPrice.text = receipt.total
        totalCash.text = receipt.cash
        cashierName.text = "Nama kasir : \(cahsierName)"
        self.key = key
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }

    func setNavbar() {
        navigationItem.title = "Resi"
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func setUIComponent() {
        emailView.isHidden = isReadingMode
        doneButton.layer.cornerRadius = 20
        doneButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        setNavbar()
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if isReadingMode {
            dismiss(animated: true, completion: nil)
        } else {
            startLoading()
            let name: String = Preference.getString(forKey: .kUsername) ?? "Guest"
            if let text = emailInput.text, !text.isEmpty {
                repo.sendReceipt(receipt: receipt, email: text, name: name)
                finishLoading()
            }
            
            if isEditingMode {
                sendTransaction()
            } else {
                finishLoading()
                dismissVC()
            }
        }
        
    }
    
    private func sendTransaction() {
        receipt.products.forEach { (product) in
            let item = ItemTransaction(id: product.id, itemName: product.name, itemCode: product.code, productId: product.productId, price: product.price, quantity: product.quantity, timestamp: product.timeStamp, transactionId: key)
            repo.addItemTransaction(itemTransaction: item, onSuccess: onSuccess(dict:)) { (err) in
                print(err.localizedDescription)
            }
        }
    }
    
    private func onSuccess(dict: [String:Any]?) {
        receipt.products.forEach { (product) in
            let newInventory = Inventory(id: product.id, name: product.name, image: product.image, category: product.category, code: product.code, cost: product.cost, margin: product.margin, price: product.price, currentStock: product.currentStock - product.quantity, minimumStock: product.minimumStock, shopId: product.shopId, userId: product.userId, timeStamp: Date().formatDate(format: .dayWithMinutes), key: product.productId)
            self.updateInventory(newValue: newInventory)
        }
    }
    
    private func updateInventory(newValue: Inventory) {
        inventoryRepo.updateInventory(key: newValue.key, inventory: newValue, onSuccess: { [weak self] (_) in
            guard let self = self else {return}
            self.finishLoading()
            self.addTabBarEmptyBadge(newValue)
            self.dismissVC()
        }) { (err) in
            print(err)
        }
    }
    
    
    private func dismissVC() {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = .reveal
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: nil)
        if let vc = navigationController?.viewControllers[1] as? TransactionListVC {
            navigationController?.popToViewController(vc, animated: false)
        } else if let vc = navigationController?.viewControllers[2] as? TransactionListVC {
            navigationController?.popToViewController(vc, animated: false)
        }
    }
    
    private func addTabBarEmptyBadge(_ newValue: Inventory) {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[0]
            if newValue.currentStock == 0 {
                let badgeValue = Int(tabItem.badgeValue ?? "0") ?? 0
                tabItem.badgeValue = String(badgeValue + 1)
            }
        }
    }
}

extension ReceiptVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        let product = receipt.products[indexPath.row]
        let total = Double(product.quantity) * product.price
        cell.textLabel?.text = "\(product.name) x\(product.quantity)"
        cell.detailTextLabel?.text = total.currencyFormat()
        return cell
    }
}
