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
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
