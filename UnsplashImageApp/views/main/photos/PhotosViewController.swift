//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController {
    
    let realm = try! Realm()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButton))
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var networkDataFetcher = NetworkDataFecher()
    var results: [Result] = []
    let loadingIndicator = UIActivityIndicatorView()
    private var selectedImages = [UIImage]()
    private var selectedUrlImages = [String]()
    private var imagesFavourite: [ImageFavourite] = []
    
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
    // MARK: - TopBar icon action
    
    @objc private func addBarButton() {
        if imagesFavourite.count == 0 {
            print("No found favorite image")
            return
        }
        realm.beginWrite()
        imagesFavourite.forEach { imagesFavourite in
            realm.add(imagesFavourite)
        }
        try! realm.commitWrite()
        selectedImages.removeAll()
        imagesFavourite.removeAll()
        collectionView.reloadData()
        print(#function)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupTopBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .white
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
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white.withAlphaComponent(0.15)
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.full
        let id = results[indexPath.row].id
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.id = id
        cell.imageUrl = imageUrl
        cell.configure(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        if let image = cell.imageView.image {
            selectedImages.append(image)
        }
        if let id = cell.id, let urlString = cell.imageUrl {
            let imageFavourite = ImageFavourite()
            imageFavourite.id = id
            imageFavourite.imageUrl = urlString
            imagesFavourite.append(imageFavourite)
            print(imagesFavourite)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
        guard let image = cell.imageView.image else { return }
        if let indexImage = selectedImages.firstIndex(of: image){
            selectedImages.remove(at: indexImage)
        }
        guard let id = cell.id else { return }
        if let x = imagesFavourite.firstIndex(where: {$0.id == id}) {
            imagesFavourite.remove(at: x)
            print(imagesFavourite)
        }
    }
}


// MARK: - UISearchBarDelegate

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        selectedImages.removeAll()
        imagesFavourite.removeAll()
        results.removeAll()
        collectionView.reloadData()
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
