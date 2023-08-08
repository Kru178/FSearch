//
//  UIStackView+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
