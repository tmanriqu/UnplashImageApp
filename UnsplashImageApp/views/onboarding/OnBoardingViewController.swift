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
    let userDefaults = UserDefaults()
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
                title: "GREETINGS",
                description: "Hello! Here you can find many photos in high definition.",
                image: UIImage(named: "onboarding_page1")!),
            OnBoardingPage(
                title: "EXPLORE",
                description: "Explore with different keywords so you don´t feel bored to see the same photos",
                image: UIImage(named: "onboarding_page2")!),
            OnBoardingPage(
                title: "SAVE",
                description: "And finally, you can save the photos you liked the most!",
                image: UIImage(named: "onboarding_page3")!)
        ]
        pageControl.numberOfPages = onBoardingPages.count
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            //evita que las celdas se mezclan entre cada tab
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
        }
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        userDefaults.setValue(true , forKey: "isOnBoardingCompleted")
        let viewController = UIStoryboard.init(name: "MainTabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTBC") as! MainTabBarController
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
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
