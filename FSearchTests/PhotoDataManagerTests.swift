//
//  PhotoDataManagerTests.swift
//  FSearchTests
//
//  Created by Sergei Krupenikov on 03.08.2023.
//

import XCTest
@testable import FSearch

final class PhotoDataManagerTests: XCTestCase {
    
    private let validData: [Photo] = [
        Photo(id: "777", owner: "777", secret: "777", server: "777", farm: 777, title: "777")
    ]
    private let error: FSError = .invalidData
    
    private let mockNetworkService = MockPhotoNetworkService()
    private lazy var photoDataManager = PhotoDataManager(networkService: mockNetworkService)
    
    func test_DataManager_SuccessfulNetworkData() {
        
        let expectation = self.expectation(description: "Waiting for data")
        
        mockNetworkService.result = .success(validData)
        
        photoDataManager.provideData(for: "777", page: 1) { result in
            
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        waitForExpectations(timeout: 3) { possibleError in
            print(possibleError.debugDescription)
        }
    }
    
    func test_DataManager_FailedNetworkData() {
        
        let expectation = self.expectation(description: "Waiting for data")
        
        mockNetworkService.result = .failure(error)
        
        photoDataManager.provideData(for: "777", page: 1) { result in
            
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3) { possibleError in
            print(possibleError.debugDescription)
        }
    }
}
