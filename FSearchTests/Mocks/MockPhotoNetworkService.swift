//
//  MockNetworkService.swift
//  FSearchTests
//
//  Created by Sergei Krupenikov on 08.08.2023.
//

import Foundation

class MockPhotoNetworkService {
    var result: Result<[Photo], FSError> = .success([Photo]())
}

// MARK: - PhotoNetworkServiceProtocol
extension MockPhotoNetworkService: PhotoNetworkServiceProtocol {
    func getSearchResult(for keyword: String, page: Int, completed: @escaping (Result<[Photo], FSError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completed(self.result)
            }
    }
}
