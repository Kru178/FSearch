//
//  Photos.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation

struct Photos: Decodable {
    let page, pages, perpage, total: Int
    var photo: [Photo]
}
