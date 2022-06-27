//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit
import Alamofire

class PhotosCollectionViewController: UICollectionViewController {
    /*
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
    }*/
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=p0iRQzBsp9h4PdkWaIGQK7PcW8pzKGcFcx3G14AwGFg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    func getPhotos() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("GOT DATA!!")
        }
        task.resume()
    }
}
