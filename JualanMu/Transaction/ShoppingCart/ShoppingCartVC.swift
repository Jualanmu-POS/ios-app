//
//  ShoppingCartVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 11/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol ShoppingCartDelegate {
    func keepCart(cart: [Product], arrSelectedIndex: [IndexPath])
}

class ShoppingCartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalChange: UILabel!
    @IBOutlet weak var cashTextBox: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var products: [Product] = []
    var repo: TransactionRepo!
    var imageRepo: ImageStorageRepo = ImageStorageRepo()
    var eventId: String = ""
    var delegate: ShoppingCartDelegate?
    var arrSelectedIndex: [IndexPath] = []
    private let MAX_AMT_LENGHT: Int = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        repo = TransactionRepo()
        setupPriceLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIComponent()
        setNavbar()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            print("going back")
            print("selectedIndex = \(arrSelectedIndex)")
            delegate?.keepCart(cart: products, arrSelectedIndex: arrSelectedIndex)
        }
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "ShoppingCartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShoppingCartCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setNavbar() {
        navigationItem.title = "Keranjang"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setUIComponent() {
        doneButton.layer.cornerRadius = 20
        doneButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        cashTextBox.keyboardType = .numberPad
        cashTextBox.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if let text = cashTextBox.text, !text.isEmpty, text.removeCurrency() != 0 {
            saveTransaction()
        } else {
            let alert = UIAlertController(title: "Gagal Membuat Receipt", message: "Anda belum memasukan nominal cash pembayaran", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
                self.cashTextBox.becomeFirstResponder()
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func saveTransaction() {
        let invoice: String = Date().epochTime()
        guard let total = totalPrice.text?.removeCurrency(), let cash = cashTextBox.text?.removeCurrency(), let change = totalChange.text?.removeCurrency(), let uid = Preference.getString(forKey: .kUserToken) else {return}
        let transaction = Transaction(id: 0, invoice: invoice, total: total, cash: cash, change: change, userId: uid, shopId: "1", timestamp: Date().formatDate(format: .dayWithMinutes), eventId: eventId, key: "")
        repo.createTransaction(transaction: transaction, onSuccess: { (_) in
            self.moveToReceipt(invoice: invoice)
        }) { (err) in
            print(err)
        }
    }

    private func moveToReceipt(invoice: String) {
        guard let cash = cashTextBox.text, let total = totalPrice.text, let change = totalChange.text else {return}
        if change.removeCurrency() > 0.0 {
            showError("Uang cash kurang")
        } else {
            let vc = ReceiptVC()
            let receipt = Receipt(products: products, cashierName: Preference.getString(forKey: .kUsername) ?? "Guest", total: total, change: change, cash: cash, invoiceNumber: invoice, transactionDate: Date().formatDate(format: .dayWithMinutes))
            vc.receipt = receipt
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
            setupExchangeLabel()
        }
    }
}

extension ShoppingCartVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell") as! ShoppingCartCell
        cell.setupCart(delegate: self, index: indexPath.row, product: products[indexPath.row], imageRepo: imageRepo)
        return cell
    }
    
}

extension ShoppingCartVC: CartDelegate {
    func onAddTapped(index: Int) {
        let item = products[index]
        if item.quantity != item.currentStock {
            products[index].quantity += 1
        } else {
            // show error
        }
        setupPriceLabel()
        tableView.reloadData()
    }
    
    func onReduceTapped(index: Int) {
        products[index].quantity -= 1
        let item = products[index]
        if item.quantity <= 0 {
            products.remove(at: index)
            arrSelectedIndex.remove(at: index)
        }
        onProductReduced()
        tableView.reloadData()
    }
    
    func onDeleteTapped(index: Int) {
        products.remove(at: index)
        arrSelectedIndex.remove(at: index)
        onProductReduced()
        tableView.reloadData()
    }
    
    private func onProductReduced() {
        setupPriceLabel()
        backToProductList()
    }
    
    private func backToProductList() {
        if products.count <= 0 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupPriceLabel() {
        var totalCount: Double = 0.0
        products.forEach { (product) in
            let count = Double(product.quantity) * product.price
            totalCount += count
        }
        totalPrice.text = "\(totalCount.currencyFormat())"
        setupExchangeLabel()
    }
    
    private func setupExchangeLabel() {
        guard let price = totalPrice.text, let cash = cashTextBox.text else {return}
        let change = price.removeCurrency() - cash.removeCurrency()
        totalChange.text = change.currencyFormat()
        totalChange.textColor = change < 0.0 ? #colorLiteral(red: 0, green: 0.5882352941, blue: 0.1411764706, alpha: 1) : .gray
    }
}
