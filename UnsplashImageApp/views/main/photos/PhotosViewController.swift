//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var networkDataFetcher = NetworkDataFecher()
    var results: [Result] = []
    let searchBar = UISearchBar()
    let loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        super.viewDidLoad()
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.placeholder = "Search here"
        searchBar.barTintColor = .black
        view.addSubview(searchBar)
        //CollectionView implement
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width - 48, height: view.frame.size.height/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white.withAlphaComponent(0.15)
        self.collectionView = collectionView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 62, width: view.frame.size.width, height: 659)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.full
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        //cell.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 32, right: 0)
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.configure(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        searchBar.resignFirstResponder()
        networkDataFetcher.fetchImages(searchTerm: searchBar.text ?? "") { (apiResponse) in
            if let apiResponse = apiResponse {
                self.results = apiResponse.results
                self.collectionView?.reloadData()
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
