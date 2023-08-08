//
//  Date+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

