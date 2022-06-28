//
//  PhotosCollectionViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 25/06/22.
//

import UIKit
import Alamofire

class PhotosViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    var results: [Result] = []
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        layout.itemSize = CGSize(width: view.frame.size.width - 48, height: view.frame.size.height/4)
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
        //collectionView?.frame = view.bounds
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 62, width: view.frame.size.width, height: 659
        )
    }
    
    func getPhotos(query: String) {
        let url = "https://api.unsplash.com/search/photos?page=1&per_page=5&query=\(query)&client_id=p0iRQzBsp9h4PdkWaIGQK7PcW8pzKGcFcx3G14AwGFg"
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlString!) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self?.results = result.results
                    self?.collectionView?.reloadData()
                    print(result.results.count) //show count images
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = results[indexPath.row].urls.full
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            print("found with \(text)")
            results = []
            collectionView?.reloadData()
            getPhotos(query: text)
        }
    }
}
