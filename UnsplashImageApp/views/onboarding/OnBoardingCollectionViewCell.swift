//
//  OnBoardingCollectionViewCell.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 24/06/22.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = String(describing: OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var onBoardingImageView: UIImageView!
    @IBOutlet weak var onBoardingTitle: UILabel!
    @IBOutlet weak var onBoardingDescription: UILabel!
    
    func setUp(_ slide: OnBoardingPage) {
        onBoardingImageView.image = slide.image
        onBoardingTitle.text = slide.title
        onBoardingDescription.text = slide.description
    }
}
