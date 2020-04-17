//
//  JualanmuTabBar.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class JualanmuTabBar: UITabBarController {
    
    let repo: InventoryRepo = InventoryRepo()
    let user: FirebaseUser = FirebaseUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        user.setUserAnonymity()
        
        let tabItem1 = UITabBarItem(title: "Gudang", image: UIImage(named: "InventoryTabIcon"), tag: 0)
        let tabItem2 = UITabBarItem(title: "Transaksi", image: UIImage(named: "TransactionTabIcon"), tag: 1)
        let tabItem3 = UITabBarItem(title: "Laporan", image: UIImage(named: "ReportTabIcon"), tag: 2)
        let tabItem4 = UITabBarItem(title: "Profil", image: UIImage(named: "ProfileTabIcon"), tag: 3)
        
        let vc1 = UINavigationController(rootViewController: setupTabBarItem(vc: InventoryListVC(), item: tabItem1, tag: tabItem1.tag))
        let vc2 = UINavigationController(rootViewController: setupTabBarItem(vc: TransactionTypeVC(), item: tabItem2, tag: tabItem1.tag))
        let vc3 = UINavigationController(rootViewController: setupTabBarItem(vc: ReportDashboardVC(), item: tabItem3, tag: tabItem1.tag))
        let vc4 = UINavigationController(rootViewController: setupTabBarItem(vc: ProfileVC(), item: tabItem4, tag: tabItem1.tag))
        
        viewControllers = [vc1, vc2, vc3, vc4]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.4196078431, alpha: 1)
        tabBar.unselectedItemTintColor = .white
        tabBar.barTintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        tabBar.isTranslucent = false
        user.saveCurrentUser()
        if Preference.getBool(forKey: .kAnonymity)! && Preference.getBool(forKey: .kHasLoggedIn)! {
            self.selectedIndex = 3
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        user.removeListener()
    }

    private func setupTabBarItem<V: UIViewController>(vc: V, item: UITabBarItem, tag: Int) -> V {
        vc.tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
        return vc
    }
}
