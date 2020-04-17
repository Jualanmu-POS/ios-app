//
//  ReportDashboardVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class ReportDashboardVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var repo: ReportRepo!
    var productReports: [ProductReport] = []
    var reportItems: [ReportItem] = []
    let titles: [String] = [
        "Penjualan Terbesar", "Penjualan Terkecil"
    ]
    let infoProductText = [
        "Produk yang paling laku akan muncul disini",
        "Produk yang jarang dibeli oleh pelanggan\nakan muncul disini"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetup()
        repo = ReportRepo(transactionRepo: TransactionRepo(), inventoryRepo: InventoryRepo())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
        setNavbar()
        repo.getProductsPerformance(onSuccess: {
            self.productReports = $0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, onFailed: nil)
        
        repo.buildReport(onComplete: {
            self.reportItems = self.repo.createItems(report: $0)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (err) in
            self.reportItems = self.repo.createItems()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        finishLoading()
        
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        // NOTE: - Registering the cell programmatically
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubtitleCell")
        
        let nib = UINib(nibName: "LaporanCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LaporanCell")
    }
    
    func setNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Laporan"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension ReportDashboardVC: LaporanCellDelegate {
    func showAllItem(index: Int) {
        let vc = SoldItemListVC()
        vc.isAscending = index == 0
        vc.productReports = index == 0 ? productReports : productReports.reversed()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReportDashboardVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return reportItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let navigationController = navigationController else {return}
        switch indexPath.row {
        case 0:
            let vc = RevenueVC()
            navigationController.pushViewController(vc, animated: true)
        case 1:
            let vc = SalesVC()
            navigationController.pushViewController(vc, animated: true)
        case 2:
            let vc = ProfitVC()
            navigationController.pushViewController(vc, animated: true)
        case 3:
            comingsoonAlert(msg: "Event")
//            navigationController.pushViewController(TopEventVC(), animated: true)
        case 4:
            comingsoonAlert(msg: "Event")
//            navigationController.pushViewController(TopStaffVC(), animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let myLabel = UILabel(frame: CGRect(x: 16, y: -4, width: view.frame.width, height: 34))
            myLabel.font = UIFont.systemFont(ofSize: 34)
            myLabel.text = "Sorotan"
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 34))
            headerView.addSubview(myLabel)
            return headerView
        } else {return nil}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaporanCell") as! LaporanCell
            cell.delegate = self
            cell.index = indexPath.row
            cell.titleLabel.text = titles[indexPath.row]
            cell.productReports = indexPath.row == 0 ? productReports : productReports.reversed()
            
            if productReports.count <= 0 {
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
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleCell")
            cell.textLabel?.text = reportItems[indexPath.row].title
            cell.detailTextLabel?.text = reportItems[indexPath.row].content
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            return cell
        }
    }
}
