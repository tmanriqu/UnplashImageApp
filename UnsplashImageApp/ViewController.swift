//
//  ViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 20/06/22.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
    
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
                    
                    let viewController = UIStoryboard.init(name: "OnBoardingViewController", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
                    
                    //let viewController = HomeViewController()
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.modalPresentationStyle = .fullScreen
                    //self.show(viewController, sender: nil)
                    //self.navigationController?.pushViewController(viewController, animated: true) //navigate to other viewcontroller with navigationcoller
                    self.present(viewController, animated: true) //viewcontroller navigate to other viewcontroller
                }
            }
    }
}

