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
    
    private let splashLogoImageView: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 180,
                height: 105
            )
        )
        imageView.image = UIImage(named: "splash_logo")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashLogoImageView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        splashLogoImageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        //rotation 360°
        //hi im a "prueba"
        fullRotation.delegate = self
        guard let _ = fullRotation.delegate else { return }
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 1
        fullRotation.repeatCount = 1
        self.splashLogoImageView.layer.add(fullRotation, forKey: "360")
        
        //vanish the image
        UIImageView.animate(
            withDuration: 2,
            animations: {
            self.splashLogoImageView.alpha = 0
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

