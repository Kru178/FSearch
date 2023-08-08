//
//  HistoryPersistenceManagerTests.swift
//  FSearchTests
//
//  Created by Sergei Krupenikov on 08.08.2023.
//

import XCTest
@testable import FSearch

final class HistoryPersistenceManagerTests: XCTestCase {

    private let manager = HistoryPersistenceManager.self
    private let keyword = "airplane"
    private let date = Date()
    private lazy var historyEntry = HistoryEntry(text: keyword, date: date)
    
    override func setUpWithError() throws {
        manager.deleteAll()
    }
    
    func test_EmptyHistory() {
        manager.retrieveHistory { result in
            switch result {
            case .success(let history):
                XCTAssertTrue(history.isEmpty)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_SaveAndRetrieveData() {
        manager.updateWith(entry: historyEntry, actionType: .add) { error in
            if error != nil { XCTFail(error!.localizedDescription)}
            
            self.manager.retrieveHistory { result in
                switch result {
                case .success(let history):
                    XCTAssertEqual(history.count, 1)
                    XCTAssertEqual(history[0].text, self.keyword)
                    XCTAssertEqual(history[0].date, self.date)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
}
