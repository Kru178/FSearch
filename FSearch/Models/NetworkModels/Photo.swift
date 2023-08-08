//
//  Photo.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation

struct Photo: Decodable, Hashable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
   // the unique identifier to support the diffable datasource
    let uuid: UUID = UUID()
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

