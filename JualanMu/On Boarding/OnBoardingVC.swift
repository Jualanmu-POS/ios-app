//
//  OnBoardingVC.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 25/10/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    var data: [OnBoarding] = []
    var repo: OnBoardingRepo!

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repo = OnBoardingRepo()
        data = repo.buildOnBoarding()
        setupCollectionView()
        Preference.set(value: true, forKey: .kOnBoarding)
        Preference.set(value: false, forKey: .kHasLoggedIn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(shouldHide: true)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "OnBoardingCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardingCell")
        collectionView.reloadData()
    }
    
    @IBAction func onSkipTapped(_ sender: UIButton) {
        registerAnonymously()
    }
    
    private func registerAnonymously() {
        startLoading()
        let firebase = FirebaseAuthentication(validation: BaseValidation())
        firebase.deleteCurrentUser()
        firebase.signInAnonymously(onSuccess: { [weak self] in
            guard let self = self else {return}
            Preference.set(value: "Guest \(Date().epochTime().prefix(8))", forKey: .kUsername)
            self.finishLoading()
            self.moveToDashboard()
        }) { [weak self] (err) in
            guard let self = self else {return}
            self.finishLoading()
            self.showError(err.localizedDescription)
        }
    }
    
    private func moveToDashboard() {
        let vc = JualanmuTabBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as? OnBoardingCell else {return UICollectionViewCell()}
        cell.onBoarding = data[indexPath.row]
        cell.index = indexPath.row
        cell.onStartTapped = registerAnonymously
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let idx = Int(collectionView.contentOffset.x / collectionView.bounds.size.width)
        updatePageControl(idx: idx)
    }
    
    private func updatePageControl(idx: Int) {
        pageControl.currentPage = idx
        skipButton.isHidden = idx == data.count - 1
    }
}
