//
//  ProductListVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var repo: TransactionRepo!
    var imageRepo: ImageStorageRepo = ImageStorageRepo()
    var list: [Product] = []
    var selectedItems: [Product] = []
    var eventId: String = ""
    var arrSelectedIndex: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductListCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductListCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        repo = TransactionRepo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIComponent()
        setNavbar()
        setSearchBar()
        getList()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func getList() {
        startLoading()
        repo.getProductList(onSuccess: { (results) in
            if results.count > 0 {
                self.setupView(results)
            }
            self.finishLoading()
        }) { (err) in
            self.finishLoading()
            print(err)
        }
    }
    
    private func setupView(_ results: [Product]) {
        list = results.filter({return $0.currentStock  > 0})
        if arrSelectedIndex.count > 0 {
            for index in arrSelectedIndex {
                self.list[index.row].isSelected = true
            }
        } else {
            selectedItems.removeAll()
        }
        collectionView.reloadData()
    }
    
    func setSelectedItems() {
        for index in arrSelectedIndex {
            print(index)
            collectionView.selectItem(at: index, animated: true, scrollPosition: .top)
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: index)
        }
        collectionView.reloadData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
//        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.8206087947, blue: 0.2826492786, alpha: 1)
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//        navigationController?.navigationBar.tintColor = UIColor.black
//    }
    
    func setUIComponent() {
        doneButton.layer.cornerRadius = 20
        doneButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setNavbar() {
        navigationItem.title = "Produk"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Item"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if selectedItems.count == 0 {
            let alert = UIAlertController(title: "Gagal membuat review", message: "Anda belum memilih produk", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let vc = ShoppingCartVC()
            vc.products = selectedItems
            vc.eventId = eventId
            vc.arrSelectedIndex = arrSelectedIndex
            vc.delegate = self
            print("productIndex = \(arrSelectedIndex)")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension ProductListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        cell.setupProductList(list[indexPath.row], imageRepo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 24.0, height: 175.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        let hasSelected = selectedItems.contains(where: { (inventory) -> Bool in
            return inventory.code == item.code
        })
        
        if hasSelected {
            let selectedItem = list.filter { (inventory) -> Bool in
                arrSelectedIndex = arrSelectedIndex.filter({$0 != indexPath})
                return item.code == inventory.code
            }.first!
            selectedItems.removeAll { (inventory) -> Bool in
                return selectedItem.code == inventory.code
            }
        } else {
            selectedItems.append(item)
            if !arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex.append(indexPath)
            }
        }
        
        list[indexPath.row].isSelected = !hasSelected
        collectionView.reloadData()
    }
}

extension ProductListVC: ShoppingCartDelegate {
    func keepCart(cart: [Product], arrSelectedIndex: [IndexPath]) {
        self.arrSelectedIndex.removeAll()
        self.selectedItems = cart
        self.arrSelectedIndex = arrSelectedIndex
    }
}

extension ProductListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    
    }
}
