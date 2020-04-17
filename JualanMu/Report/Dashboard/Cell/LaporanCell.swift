//
//  LaporanCell.swift
//  JualanMu
//
//  Created by Eibiel Sardjanto on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

protocol LaporanCellDelegate {
    func showAllItem(index:Int)
}

class LaporanCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    var delegate: LaporanCellDelegate?
    var index: Int?
    var productReports: [ProductReport] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //remove cell separator
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
    
    func collectionViewSetup() {
        let nib = UINib(nibName: "LaporanCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    @IBAction func detailBtnTapped(_ sender: Any) {
        delegate?.showAllItem(index: index ?? 0)
    }
}

extension LaporanCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productReports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LaporanCollectionCell
        cell.setupCell(productReports[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115.0, height: 115.0)
    }
}
