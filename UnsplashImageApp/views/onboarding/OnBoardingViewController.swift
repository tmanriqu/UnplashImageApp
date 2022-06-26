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
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == onBoardingPages.count - 1 {
                nextButton.alpha = 1
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.alpha = 0
                nextButton.setTitle(" ", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        onBoardingPages = [
            OnBoardingPage(
                title: "Delicious Dishes",
                description: "Experience a variety of amazing dishes from different cultures around the world.",
                image: UIImage(named: "onboarding_image_1")!),
            OnBoardingPage(
                title: "World-Class Chefs",
                description: "Our dishes are prepared by only the best.",
                image: UIImage(named: "onboarding_image_2")!),
            OnBoardingPage(
                title: "Instant World-Wide Delivery",
                description: "Your orders will be delivered instantly irrespective of your location around the world.",
                image: UIImage(named: "onboarding_image_3")!)
        ]
        pageControl.numberOfPages = onBoardingPages.count
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == onBoardingPages.count - 1 {
            let viewController = UIStoryboard.init(name: "MainTabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTBC") as! MainTabBarController
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.indentifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setUp(onBoardingPages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = collectionView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}
