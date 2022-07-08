//
//  UIViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 7/07/22.
//

import UIKit

extension UIViewController {

    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 40))
        toastLabel.backgroundColor = UIColor(named: "welcomescreen_background")!.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor(named: "title")
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        //Hide
        UIView.animate(
            withDuration: 4.0,
            delay: 0.1,
            options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
            },
            completion: { (isCompleted) in
                toastLabel.removeFromSuperview()
            }
        )
    }
}
