//
//  OnBoardingRepo.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 05/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
class OnBoardingRepo {
    
    func buildOnBoarding() -> [OnBoarding] {
        var data: [OnBoarding] = []
        data.append(OnBoarding(image: "Onboarding1", title: "Pengaturan Stok", subtitle: "Catat keuangan Anda dengan mudah dan teratur untuk mengetahui performa bisnis Anda."))
        data.append(OnBoarding(image: "Onboarding2", title: "Laporan Keuangan", subtitle: "Atur dan lacak stok barang yang akan Anda jual baik sehari-hari ataupun saat event tertentu."))
        data.append(OnBoarding(image: "Onboarding3", title: "Transaksi", subtitle: "Sistem pencatatan transaksi yang mudah digunakan oleh penjual."))
        return data
    }
}
