//
//  FavouriteViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 28/06/22.
//

import UIKit
import RealmSwift

class FavouriteViewController: UIViewController {
    
    let realm = try! Realm()
    private lazy var deleteBarButtonIcon: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButton))
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let loadingIndicator = UIActivityIndicatorView()
    private var imagesFavourite: [ImageFavourite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupLoadingIndicator()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getImagesFavourite()
        collectionView.reloadData()
        updateButtonIconState()
        print("DidAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("WillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DidDisappear")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.frame.size.width, height: view.frame.size.height - 92) //height: 659
    }
    // MARK: - TopBar icon action
    @objc private func deleteBarButton() {
        realm.beginWrite()
        realm.delete(realm.objects(ImageFavourite.self))
        try! realm.commitWrite()
        imagesFavourite = []
        collectionView.reloadData()
        updateButtonIconState()
        print(#function)
    }
    
    // MARK: - Setup UI Elements
    private func setupTopBar() {
        let titleLabel = UILabel()
        titleLabel.text = "FAVOURITES"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItem = deleteBarButtonIcon
        deleteBarButtonIcon.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/3, height: view.frame.size.height/4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavouriteItemCollectionViewCell.self, forCellWithReuseIdentifier: FavouriteItemCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        //collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white.withAlphaComponent(0.15)
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    // MARK: - Functions
    private func getImagesFavourite() {
        imagesFavourite = []
        for imageFavourite in realm.objects(ImageFavourite.self) {
            imagesFavourite.append(imageFavourite)
        }
    }
    private func updateButtonIconState() {
        deleteBarButtonIcon.isEnabled = imagesFavourite.count > 0
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = imagesFavourite[indexPath.row].imageUrl
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteItemCollectionViewCell.identifier, for: indexPath) as? FavouriteItemCollectionViewCell else { return UICollectionViewCell() }
        cell.configureFavouriteItem(with: url)
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesFavourite.count
    }
}
