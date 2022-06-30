//
//  NetworkDataFetcher.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 28/06/22.
//

import Foundation

class NetworkDataFecher {
    
    var networkService = NetworkService()
    func fetchImages(searchTerm: String, completion: @escaping (Response?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return 
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                print(error)
            }
        }
    }
}
