//
//  OnBoardingViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 24/06/22.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    var onBoardingPages: [OnBoardingPage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.indentifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setUp(onBoardingPages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingPages.count
    }
}
