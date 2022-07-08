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
    private let alert = UIAlertController(title: "UnsplashImageApp", message: "Are you sure you want to delete the selected images?", preferredStyle: UIAlertController.Style.alert)
    @IBOutlet weak var collectionView: UICollectionView!
    private var imagesFavourite: [ImageFavourite] = []
    private var numberOfSelectedImagesFavourite: Int? {
        get { collectionView.indexPathsForSelectedItems?.count }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "topbar_background")
        setupTopBar()
        setupCollectionView()
        setupAlert()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getImagesFavourite()
        collectionView.reloadData()
        updateButtonIconState()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.frame.size.width, height: view.frame.size.height) //height: 659
    }
    // MARK: - TopBar icon action
    @objc private func deleteBarButton() {
        if (numberOfSelectedImagesFavourite != 0) {
            self.present(alert, animated: true, completion: nil)
        }
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
        deleteBarButtonIcon.tintColor = UIColor(named: "topbar_content")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "topbar_content")
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
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor(named: "system_background")
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    private func setupAlert() {
        alert.addAction(
            UIAlertAction(
                title: "YES",
                style: UIAlertAction.Style.default,
                handler: { [self] _ in
                    /*
                    realm.beginWrite()
                    realm.delete(realm.objects(ImageFavourite.self))
                    try! realm.commitWrite()
                    imagesFavourite = []
                    collectionView.reloadData()
                    updateButtonIconState()*/
                    realm.beginWrite()
                    collectionView.indexPathsForSelectedItems?.forEach { indexPath in
                        realm.delete(imagesFavourite[indexPath[1]])
                        imagesFavourite.remove(at: indexPath[1])
                    }
                    try! realm.commitWrite()
                    collectionView.reloadData()
                    updateButtonIconState()
                }
            )
        )
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    // MARK: - Functions aux
    private func getImagesFavourite() {
        imagesFavourite = []
        for imageFavourite in realm.objects(ImageFavourite.self) {
            imagesFavourite.append(imageFavourite)
        }
    }
    private func updateButtonIconState() {
        deleteBarButtonIcon.isEnabled = numberOfSelectedImagesFavourite ?? 0 > 0
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateButtonIconState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateButtonIconState()
    }
}
