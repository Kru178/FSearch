//
//  UIViewController+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit
// MARK: - alert
extension UIViewController {
    enum AlertType {
        case information
        case action
    }
    
    typealias Handler = ((UIAlertAction) -> ())?
    
    func showAlert(alertText: String, alertMessage: String, alertType: AlertType, handler: Handler = nil) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        switch alertType {
        case .information:
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        case .action:
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: handler))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - empty view
extension UIViewController {
    func showEmptyStateView(with message: String, in view: UIView, withImage: Bool) {
        let emptyStateView = EmptyStateView(message: message, withImage: withImage)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func dismissEmptyStateView() {
        view.subviews.forEach { view in
            if view is EmptyStateView {
                view.removeFromSuperview()
            }
        }
    }
}
