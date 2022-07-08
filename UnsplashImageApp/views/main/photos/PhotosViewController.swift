//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController {
    
    let total_page = 2000
    var current_page = 1
    let realm = try! Realm()
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButton))
    }()
    private var collectionView: UICollectionView!
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    var networkDataFetcher = NetworkDataFecher()
    var results: [Result] = []
    private var loadingIndicator = UIActivityIndicatorView()
    private var imagesFavouriteSelected: [ImageFavourite] = []
    private var numberOfSelectedImages: Int? {
        get { collectionView?.indexPathsForSelectedItems?.count }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "system_background")
        statusBarColor(color: "statusbar")
        setupTopBar()
        setupSearchBar()
        setupCollectionView()
        setupLoadingIndicator()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 16, width: view.frame.size.width, height: view.frame.size.height - 32) //height: 659
    }
    // MARK: - TopBar icon action
    @objc private func addBarButton() {
        realm.beginWrite()
        imagesFavouriteSelected.forEach { imagesFavourite in
            realm.add(imagesFavourite)
        }
        try! realm.commitWrite()
        imagesFavouriteSelected.removeAll()
        collectionView.indexPathsForSelectedItems?.forEach { it in
            print(results[it[1]])
            collectionView.deselectItem(at: it, animated: false)
        }
        updateButtonIconState()
        numberLabel.text = String(numberOfSelectedImages!)
        showToast(message: "Images added to favorites", font: .systemFont(ofSize: 16.0))
        print(#function)
    }
    
    // MARK: - Setup UI Elements
    private func setupTopBar() {
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(named: "topbar_content")
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        numberLabel.text = "0"
        numberLabel.textColor = UIColor(named: "topbar_content")
        addBarButtonItem.isEnabled = false
        addBarButtonItem.tintColor = UIColor(named: "topbar_content")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "topbar_content")
        navigationItem.rightBarButtonItems = [addBarButtonItem, UIBarButtonItem.init(customView: numberLabel)]
    }
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.tintColor = UIColor(named: "topbar_content")
        searchController.searchBar.searchTextField.textColor = UIColor(named: "topbar_content")
        searchController.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "topbar_content")
        searchController.searchBar.placeholder = "Search here"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesBottomBarWhenPushed = true
        searchController.searchBar.delegate = self
    }
    private func setupLoadingIndicator() {
        loadingIndicator.color = UIColor(named: "loading_indicator")
        loadingIndicator.isHidden = false
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width - 48, height: view.frame.size.height/2)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor(named: "system_background")
        view.addSubview(collectionView)
    }
    // MARK: - Functions aux
    private func updateButtonIconState() {
        addBarButtonItem.isEnabled = numberOfSelectedImages ?? 0 > 0
    }
    private func statusBarColor(color: String) {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            let statusBar = UIView(frame: (keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor(named: color)
            keyWindow?.addSubview(statusBar)
        }
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.small
        let photoId = results[indexPath.row].id
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.photoId = photoId
        cell.imageUrl = imageUrl
        cell.configureItem(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        if let photoId = cell.photoId, let urlString = cell.imageUrl {
            let imageFavourite = ImageFavourite()
            imageFavourite.photoId = photoId
            imageFavourite.imageUrl = urlString
            imagesFavouriteSelected.append(imageFavourite)
        }
        numberLabel.text = String(numberOfSelectedImages ?? 0)
        updateButtonIconState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
        guard let photoId = cell.photoId else { return }
        if let index = imagesFavouriteSelected.firstIndex(where: {$0.photoId == photoId}) {
            imagesFavouriteSelected.remove(at: index)
        }
        numberLabel.text = String(numberOfSelectedImages ?? 0)
        updateButtonIconState()
    }
}

// MARK: - UISearchBarDelegate
extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        searchBar.resignFirstResponder()
        imagesFavouriteSelected.removeAll()
        numberLabel.text = String(numberOfSelectedImages ?? 0)
        results.removeAll()
        collectionView.reloadData()
        networkDataFetcher.fetchImages(searchTerm: searchBar.text ?? "") { (apiResponse) in
            if let apiResponse = apiResponse {
                self.results = apiResponse.results
                self.collectionView?.reloadData()
                self.loadingIndicator.stopAnimating()
            } else {
                self.showToast(message: "Empty result", font: .systemFont(ofSize: 18.0))
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imagesFavouriteSelected.removeAll()
        results.removeAll()
        collectionView.reloadData()
        updateButtonIconState()
    }
}
