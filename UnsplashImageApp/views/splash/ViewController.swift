//
//  ViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 20/06/22.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
    let userDefaults = UserDefaults()

    @IBOutlet weak var splashLogoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        fullRotation.delegate = self
        guard let _ = fullRotation.delegate else { return }
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 1
        fullRotation.repeatCount = 1
        self.splashLogoImage.layer.add(fullRotation, forKey: "360")
        
        //vanish the image
        UIImageView.animate(
            withDuration: 2,
            animations: {
            self.splashLogoImage.alpha = 0
            }) { isCompleted in
                if isCompleted {
                    if let _ = self.userDefaults.value(forKey: "isOnBoardingCompleted") {
                        let viewController = UIStoryboard.init(name: "MainTabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTBC") as! MainTabBarController
                        viewController.modalTransitionStyle = .crossDissolve
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true)
                        
                    } else {
                        let viewController = UIStoryboard.init(name: "OnBoardingViewController", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
                        viewController.modalTransitionStyle = .crossDissolve
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true)
                    }
                }
            }
    }
}

