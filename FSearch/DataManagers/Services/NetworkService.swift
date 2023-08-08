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
    private let baseUrl = Constants.URLs.NetworkService.baseUrl
    
    init() {}
}

// MARK: - PhotoNetworkServiceProtocol methods
extension NetworkService: PhotoNetworkServiceProtocol {
    func getSearchResult(for keyword: String, page: Int, completed: @escaping (Result<[Photo], FSError>) -> Void) {
        let requestPhrase = keyword.replaceWhitespacesWithUnderscores()
        let endpoint = baseUrl + "\(requestPhrase)&per_page=20&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
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
