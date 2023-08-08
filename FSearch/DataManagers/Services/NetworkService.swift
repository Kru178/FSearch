//
//  NetworkManager.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 04.08.2023.
//

import UIKit
// MARK: - PhotoNetworkServiceProtocol
protocol PhotoNetworkServiceProtocol {
    func getSearchResult(for keyword: String, page: Int, completed: @escaping (Result<[Photo], FSError>) -> Void)
}

// MARK: - NetworkService
final class NetworkService {    
    private func prepareUrl(for keyword: String, page: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "6af377dc54798281790fc638f6e4da5e"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "text", value: keyword),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        let url = components.url
        return url
    }
    
    init() {}
}

// MARK: - PhotoNetworkServiceProtocol methods
extension NetworkService: PhotoNetworkServiceProtocol {
    func getSearchResult(for keyword: String, page: Int, completed: @escaping (Result<[Photo], FSError>) -> Void) {
        let requestPhrase = keyword.replaceWhitespacesWithUnderscores()
        
        guard let url = prepareUrl(for: requestPhrase, page: page) else {
            completed(.failure(.badRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SearchResult.self, from: data)
                completed(.success(result.photos.photo))
            } catch {
                completed(.failure(.invalidData))
              }
        }
        task.resume()
    }
}
