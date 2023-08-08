//
//  UITableView+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessiveCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
