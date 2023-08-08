//
//  String+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation

extension String {
    // helper method to convert search input with whitespaces into a url compatible string
    func replaceWhitespacesWithUnderscores() -> String {
        self.replacingOccurrences(of: " ", with: "_")
    }
}
