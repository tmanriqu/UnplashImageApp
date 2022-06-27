//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit
import Alamofire

class PhotosCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .orange
        setUpNavigationBar()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    private func setUpNavigationBar() {
        let title = UILabel()
        title.text = "PHOTOS"
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .link
        return cell
    }
}
