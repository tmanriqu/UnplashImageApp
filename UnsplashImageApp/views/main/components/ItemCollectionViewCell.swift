//
//  ItemCollectionViewCell.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 27/06/22.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ItemCollectionViewCell"
    var id: String?
    var imageUrl: String?
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let checkmark: UIImageView = {
        let image = UIImage(named: "checkmark_icon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        updateSelectedState()
        setupCheckmark()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupCheckmark() {
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func updateSelectedState() {
        imageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }

    func configure(with urlString: String) {
        imageView.image = UIImage(named: "placeholder")
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.imageView.image = image
                }
            }
        }.resume()
    }
}
