//
//  SoldItemListVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 18/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class SoldItemListVC: UIViewController {

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var isAscending: Bool = false
    var productReports: [ProductReport] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavBar()
        setSearchBar()
        setSort()
    }
    
    func setNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Penjualan"
    }
    
    func collectionViewSetup() {
        let nib = UINib(nibName: "SoldItemCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setSearchBar() {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Item"
    //        searchController.searchBar.searchTextField.backgroundColor = .white
            navigationItem.searchController = searchController
            definesPresentationContext = true
        }

    func setSort() {
        sortButton.setTitle(isAscending ? "Urutkan: Paling banyak" : "Urutkan: Paling sedikit", for: .normal)
        sortButton.setImage(UIImage(systemName: isAscending ? "chevron.up" : "chevron.down"), for: .normal)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        isAscending.toggle()
        productReports = productReports.reversed()
        collectionView.reloadData()
        setSort()
    }
}

extension SoldItemListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productReports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SoldItemCell
        let productReport = productReports[indexPath.row]
        cell.skuLabel.text = productReport.sku
        cell.soldQtyLabel.text = "Terjual: \(productReport.qty)"
        cell.setupCell(productReport)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 24.0, height: 175.0)
    }
}

extension SoldItemListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
    
}
