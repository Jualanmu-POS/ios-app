//
//  TransactionTypeVC.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class TransactionTypeVC: UIViewController {
    
    @IBOutlet var transactionTypeButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIComponent()
        setNavbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func nonEventBtnTapped(_ sender: Any) {
        navigationController?.pushViewController(TransactionListVC(), animated: true)
    }
    
    @IBAction func eventBtnTapped(_ sender: Any) {
//        comingsoonAlert(msg: "Event")
        navigationController?.pushViewController(EventListVC(), animated: true)
    }
    
    func setUIComponent(){
        for transactionTypeButton in transactionTypeButtons {
            transactionTypeButton.layer.cornerRadius = 15
        }
    }
    
    func setNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Transaksi"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
}
