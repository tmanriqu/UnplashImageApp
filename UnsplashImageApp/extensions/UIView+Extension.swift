//
//  UIView+Extension.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 24/06/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
