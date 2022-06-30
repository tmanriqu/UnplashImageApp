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
    let loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupSearchBar()
        setupLoadingIndicator()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.frame.size.width, height: view.bounds.size.height - 144) //height: 659
    }
    
    private func setupTopBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.placeholder = "Search here"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesBottomBarWhenPushed = true
        searchController.searchBar.delegate = self
    }
    private func setupLoadingIndicator() {
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    private func setupCollectionView() {
        //CollectionView implement
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width - 48, height: view.frame.size.height/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white.withAlphaComponent(0.15)
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.full
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
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
