//
//  InventoryListVC.swift
//  JualanMu
//
//  Created by Hendy Sen on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class InventoryListVC: UIViewController {

    var inventories: [Inventory] = []
    var repo: InventoryRepo = InventoryRepo()
    var imageRepo: ImageStorageRepo = ImageStorageRepo()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData : [Inventory] = []
    var isFiltering: Bool = false
    
    @IBOutlet weak var tableView: UITableView!    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar()
        getList()
    }
    
    private func getList() {
        startLoading()
        repo.retrieveData(onSuccess: { (results) in
            self.setupView(results)
            self.finishLoading()
        }) { (err) in
            self.finishLoading()
            self.tableView.reloadData()
        }
    }
    
    private func setupView(_ results: [Inventory]) {
        inventories = results
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.isEnabled = true
        initializeTabBadge(results)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        if inventories.count > 0 {
            navigationItem.rightBarButtonItem = .init(title: "Tambah", style: .done, target: self, action: #selector(addItem))
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib.init(nibName: "InventoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "InventoryCell")
        tableView.register(UINib(nibName: "EmptyViewCell", bundle: nil), forCellReuseIdentifier: "EmptyViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func navBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
        navBarAppearance.shadowColor = .clear
        navigationItem.title = "Gudang"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari Nama Barang"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "chevron.up.chevron.down"), for:.bookmark, state: .normal)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //state of the search nar text (empty or not)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func showSortActionSheet() {
        
        let alert = UIAlertController(title: "Urutkan", message: "Urutkan", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Harga Termahal", style: .default, handler: { (_) in
            self.inventories.sort { $0.price > $1.price }
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Harga Termurah", style: .default, handler: { (_) in
            self.inventories.sort { $0.price < $1.price }
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Stok Terbanyak", style: .default, handler: { (_) in
            self.inventories.sort { $0.currentStock > $1.currentStock }
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Stok Tersedikit ", style: .default, handler: { (_) in
            self.inventories.sort { $0.currentStock < $1.currentStock }
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Batal", style: .destructive, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func initializeTabBadge(_ results: [Inventory]) {
        var emptyStock = 0
        for inventory in results {
            emptyStock += inventory.currentStock == 0 ? 1 : 0
        }
        let tabItem = tabBarController?.tabBar.items![0]
        tabItem?.badgeValue = emptyStock == 0 ? nil : String(emptyStock)
    }
    
    @objc func addItem() {
        let vc = CreateInventoryVC(nibName: "CreateInventoryVC", bundle: nil)
        vc.isEditingMode = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension InventoryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inventories.count == 0 {
            return 1
        } else {
            return isFiltering ? filteredData.count : inventories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if inventories.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyViewCell", for: indexPath) as! EmptyViewCell
            cell.setupView(title: "Anda tidak memiliki daftar barang", subtitle: "Yuk isi gudangmu!", image: "Onboarding2", buttonTitle: "Tambah Barang")
            cell.emptyView.actionTapped {
                let vc = CreateInventoryVC()
                vc.isEditingMode = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            cell.setupInventory(isFiltering ? filteredData[indexPath.row] : inventories[indexPath.row], imageRepo)
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if inventories.count > 0 {
            showActions(item: isFiltering ? filteredData[indexPath.row] : inventories[indexPath.row])
        }
    }
    
    private func showActions(item: Inventory) {
        let alert: UIAlertController = UIAlertController(title: "Pilih Aksi", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ubah", style: .default, handler: { [weak self] (_) in
            guard let self = self else {return}
            self.moveToEditView(item)
        }))
        alert.addAction(UIAlertAction(title: "Salin", style: .default, handler: { [weak self] (_) in
            guard let self = self else {return}
            var data = item
            self.duplicateItem(&data)
        }))
        alert.addAction(UIAlertAction(title: "Batal", style: .destructive, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func moveToEditView(_ item: Inventory) {
        let vc = CreateInventoryVC()
        vc.isEditingMode = true
        vc.inventory = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func duplicateItem(_ item: inout Inventory) {
        startLoading()
        item.key = ""
        repo.saveToFirebase(inventory: item, onSuccess: { (_) in
            self.showSuccessInfo()
        }) { (err) in
            self.showError(err.localizedDescription)
        }
        finishLoading()
    }
    
    private func showSuccessInfo() {
        let alert: UIAlertController = UIAlertController(title: "Item berhasil ditambahkan", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            self.getList()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension InventoryListVC: InventoryDelegate {
    
    func deleteItem(index: Int) {
        simpleAlert(msg: "Apakah anda ingin menghapus \(inventories[index].name)?", onPositiveTapped: {
            self.repo.removeInventory(with: self.inventories[index].key, onSuccess: { (_) in
                if self.inventories[index].image != "" {
                    self.imageRepo.deleteImage(imagePath: self.inventories[index].image)
                }
                self.removeItem(index: index)
            }) { (err) in
                print(err)
            }
        })
    }
    
    func removeItem(index: Int) {
        inventories.remove(at: index)
        tableView.reloadData()
        if inventories.count == 0 {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
}

extension InventoryListVC: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        showSortActionSheet()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        defaultView()
    }
    
    private func defaultView() {
        isFiltering = false
        filteredData.removeAll()
        tableView.reloadData()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        isFiltering = true
        filteredData = inventories.filter({return $0.name.lowercased().contains(searchText.lowercased())})
        tableView.reloadData()
    }
}
