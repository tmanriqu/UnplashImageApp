//
//  NetworkService.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 28/06/22.
//

import Foundation

class NetworkService {
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        createDataTask(from: request, completion: completion).resume()
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Client-ID p0iRQzBsp9h4PdkWaIGQK7PcW8pzKGcFcx3G14AwGFg"
        return headers
    }
    
    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["page"] = String(1)
        parameters["per_page"] = String(5)
        parameters["query"] = searchTerm
        return parameters
    }
    
    private func url(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)
            
        }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data,error)
            }
        }
    }
}
