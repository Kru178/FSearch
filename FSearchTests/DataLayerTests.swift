//
//  DataLayerTests.swift
//  FSearchTests
//
//  Created by Sergei Krupenikov on 08.08.2023.
//

import XCTest
@testable import FSearch

final class DataLayerTests: XCTestCase {

    func test_SearchResult_ValidJSONData() {
        let data = validResultJSON.data(using: .utf8)!
        do {
            let response = try JSONDecoder().decode(SearchResult.self, from: data)
            XCTAssertEqual(response.stat, "ok")
            
            let photos = response.photos
            
            XCTAssertEqual(photos.pages, 5445)
            XCTAssertEqual(photos.perpage, 20)
            XCTAssertEqual(photos.total, 108895)
            
            let photo = photos.photo[0]
            
            XCTAssertEqual(photo.id, "53102194333")
            XCTAssertEqual(photo.secret, "f65077b79e")
            XCTAssertEqual(photo.farm, 66)
        } catch {
            XCTFail("unable to parse data")
        }
    }
}
