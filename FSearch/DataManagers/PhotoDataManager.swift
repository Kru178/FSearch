//
//  PhotoDataManager.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 07.08.2023.
//

import Foundation
// MARK: - PhotoDataManagerProtocol
protocol PhotoDataManagerProtocol {
    func provideData(for keyword: String, page: Int, completion: @escaping (Result<[Photo], FSError>) -> ())
}

// MARK: - PhotoDataManager
class PhotoDataManager {
    private let networkService: PhotoNetworkServiceProtocol
    
    init(networkService: PhotoNetworkServiceProtocol) {
        self.networkService = networkService
    }
}

// MARK: - PhotoDataManagerProtocol methods
extension PhotoDataManager: PhotoDataManagerProtocol {
    func provideData(for keyword: String, page: Int, completion: @escaping (Result<[Photo], FSError>) -> ()) {
        networkService.getSearchResult(for: keyword, page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
