//
//  MainTabBarController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            generateNavigationController(rootViewController: PhotosViewController(), title: "Photos", image: UIImage(named: "photoscollection_icon")!),
            generateNavigationController(rootViewController: FavouriteViewController(), title: "Favourites", image: UIImage(named: "favourite_icon")!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.shadowColor = .clear
        tabBarApperance.backgroundColor = UIColor(named: "topbar_background")
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = UIColor(named: "topbar_background")
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.navigationBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            navigationVC.tabBarItem.standardAppearance = tabBarApperance
            navigationVC.tabBarItem.scrollEdgeAppearance = tabBarApperance
        } 
        navigationVC.navigationBar.standardAppearance = appearance
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.badgeColor = .red
        return navigationVC
    }
}
